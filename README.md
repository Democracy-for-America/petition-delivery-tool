## Usage

1. Rename the `credentials.sh.example` file to `credentials.sh` and set your organization's ActionKit MySQL credentials.
2. Build a CSV of legislative targets (US Senators or Representatives) by running either `buildhouse.sh` or `buildsenate.sh`.
3. Generate a CSV of petition signatures by running `csvgen.sh`. (Edit the file to select which petition pages you'd like to pull signatures from - they'll be automatically de-duped)
4. Customize the cover letter & signature template in `coverletter.html`.
5. Generate an individualized cover letter & signature sheet PDF for each legislator by running `pdfgen.rb`.