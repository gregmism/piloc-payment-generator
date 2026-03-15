import time
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

SPRITE_PATH = Path("references/icons-sprite.svg")
OUTPUT = Path("output")

def load_sprite():
    return SPRITE_PATH.read_text(encoding="utf-8")

def inject(path: Path, sprite: str):
    try:
        content = path.read_text(encoding="utf-8")
        if "<body>" in content and "icon-" in content and "icons-sprite.svg" not in content:
            content = content.replace("<body>", f"<body>\n<!-- sprite -->\n{sprite}\n<!-- /sprite -->", 1)
            path.write_text(content, encoding="utf-8")
            print(f"✓ sprite injecté → {path.name}")
        else:
            print(f"⏭  ignoré (déjà injecté ou pas d'icônes) → {path.name}")
    except Exception as e:
        print(f"✗ erreur sur {path.name} : {e}")

class Handler(FileSystemEventHandler):
    def __init__(self):
        self.sprite = load_sprite()

    def on_created(self, event):
        if event.src_path.endswith(".html"):
            time.sleep(0.3)
            inject(Path(event.src_path), self.sprite)

    def on_modified(self, event):
        if event.src_path.endswith(".html"):
            time.sleep(0.3)
            inject(Path(event.src_path), self.sprite)

if __name__ == "__main__":
    if not SPRITE_PATH.exists():
        print(f"✗ Sprite introuvable : {SPRITE_PATH}")
        exit(1)

    OUTPUT.mkdir(exist_ok=True)
    handler = Handler()
    observer = Observer()
    observer.schedule(handler, str(OUTPUT), recursive=False)
    observer.start()
    print(f"👀 Watching {OUTPUT}/ — Ctrl+C pour arrêter")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
