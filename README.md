# Copy Absolute Path for macOS Finder

Adds **Copy Absolute Path** to Finder's right-click **Quick Actions** menu. It
copies the absolute path of the selected file or folder inside safe double
quotes, ready to paste after commands such as `ls`, `cd`, `cat`, or `open`.
When multiple items are selected, their paths are copied one per line.

## Install

Clone the repository and install the Quick Action:

```sh
git clone https://github.com/chengruo/finder-copy-path.git
cd finder-copy-path
make install
```

Or run it as a single command:

```sh
git clone https://github.com/chengruo/finder-copy-path.git && cd finder-copy-path && make install
```

Then right-click a file or folder in Finder and choose:

**Quick Actions → Copy Absolute Path**

If it is not visible, enable it in **System Settings → General → Login Items &
Extensions → Finder** (the exact wording varies slightly by macOS version), or
use **Quick Actions → Customize…** from Finder.

You can also refresh the Services cache manually:

```sh
/System/Library/CoreServices/pbs -update
```

Then close and reopen the Finder window. The item may appear under either
**Quick Actions** or **Services**, depending on the macOS version and how many
Finder extensions are enabled.

To verify that macOS can parse the workflow:

```sh
/System/Library/CoreServices/pbs -read_bundle \
  "$HOME/Library/Services/Copy Absolute Path.workflow"
```

The output should contain `NSMessage = runWorkflowAsService` and
`NSSendFileTypes = ("public.item")`.

The installer places the workflow at:

`~/Library/Services/Copy Absolute Path.workflow`

No administrator access, code signing, App Store account, or background process
is required.

## Uninstall

```sh
make uninstall
```

## Test

```sh
make test
```

The test validates the workflow bundle and exercises the clipboard script with
paths containing spaces and Unicode characters.
