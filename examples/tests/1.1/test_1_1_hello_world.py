from pathlib import Path
import subprocess
import sys


def test_hello_world_example_prints_expected_message():
    script = Path(__file__).resolve().parents[2] / "1.1" / "1-1-hello-world.py"

    result = subprocess.run(
        [sys.executable, str(script)],
        check=True,
        capture_output=True,
        text=True,
    )

    assert result.stdout == "Hello, world!\n"
    assert result.stderr == ""
