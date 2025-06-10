# iias-sysstats

`iias-sysstats` is a shell-based system statistics collection tool designed to capture and organize system metrics for analysis. It is especially useful in IBM Integrated Analytics System (IIAS) environments.

## Features

- Collects system statistics using shell scripts.
- Organizes collected data into structured directories.
- Designed for use directly on the IIAS host OS (outside of Db2 containers).
- Generates a compressed archive of captured data for easy transfer and analysis.

## Getting Started

### Prerequisites

- IBM Integrated Analytics System (IIAS) host access
- Root privileges on the IIAS host OS
- Bash shell and standard Unix utilities:
  - `sar` (requires `sysstat` package)

### Download the repo

You can obtain this repository in two ways:

**Option 1**: Clone with Git (recommended)
If you have Git installed, you can clone the repository using:

`git clone https://github.com/daniel-hancock33/iias-sysstats.git`

This will create a local copy of the repository on your machine.

**Option 2**: Download as ZIP
Visit the repository page: https://github.com/daniel-hancock33/iias-sysstats

Extract the downloaded ZIP file to access the contents.

### Installation

1. SSH into the IIAS host OS as root (not into the Db2 container).

2. Create the target directory for the tool:

   ```bash
   mkdir -p /opt/ibm/appliance/storage/scratch/iias-sysstats
   ```

3. Upload all the files and directories from this GitHub repository to:

   ```
   /opt/ibm/appliance/storage/scratch/iias-sysstats
   ```

4. Navigate to the directory:

   ```bash
   cd /opt/ibm/appliance/storage/scratch/iias-sysstats
   ```

### Usage

Run the `capture.sh` script to start collecting system statistics:

```bash
./capture.sh
```

After the capture completes, archive the results using:

```bash
tar zcvf iias-sysstat-data.tgz ./data
```

This will create a compressed tarball of the `data/` directory that can be downloaded or transferred for analysis.

## Project Structure

- `capture.sh`: Main script to initiate data collection.
- `data/`: Directory where collected system statistics are stored.
- `lib/`: Contains auxiliary scripts and functions used by `capture.sh`.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.

## Acknowledgments

[daniel-hancock33](https://github.com/daniel-hancock33) for creating and maintaining this project.
