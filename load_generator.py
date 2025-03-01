import os


def generate_stress(duration=300):
    command = f"stress-ng --cpu 2 --timeout {duration}s"
    os.system(command)


if __name__ == "__main__":
    generate_stress()
