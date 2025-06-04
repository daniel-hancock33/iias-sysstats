# iias-sysstats

`iias-sysstats` is a shell-based system statistics collection tool designed to capture and organize system metrics for analysis.

## Features

- Collects system statistics using shell scripts.
- Organizes collected data into structured directories.
- Provides a foundation for monitoring and analyzing system performance.

## Getting Started

### Prerequisites

- Unix-like operating system (Linux, macOS, etc.)
- Bash shell
- Standard Unix utilities (e.g., `top`, `vmstat`, `iostat`)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/daniel-hancock33/iias-sysstats.git
   ```

2. Navigate to the project directory:

   ```bash
   cd iias-sysstats
   ```

### Usage

Run the `capture.sh` script to start collecting system statistics:

```bash
./capture.sh
```

The script will execute various system commands and store their outputs in the `data/` directory for further analysis.

## Project Structure

- `capture.sh`: Main script to initiate data collection.
- `data/`: Directory where collected system statistics are stored.
- `lib/`: Contains auxiliary scripts and functions used by `capture.sh`.
