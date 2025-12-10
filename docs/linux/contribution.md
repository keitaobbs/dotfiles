# Linux Kernel Contribution

1. Check mainling list to avoid contribution conflict

For example, you can search the below query on your browser.

```
site:https://lkml.org/ <keyword>
```

2. Clone base tree

If a maintainer has his own tree, use it.
Latest stable branch can be used.

```
$ scripts/get_maintainer.pl --separator , --nokeywords --nogit --nogit-fallback --norelestats drivers/mmc/core/sd.c
Ulf Hansson <ulf.hansson@linaro.org>,linux-mmc@vger.kernel.org,linux-kernel@vger.kernel.org

$ git clone https://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc.git -b mmc-v6.11
```

3. Apply/Create patch

```
$ git am xxxxxxxx.patch
$ git commit --amend --signoff
$ git format-patch -1 <Commit ID> [-v <version>] --to=example01@example.com --cc=example01@example.com --cc=example02@example.com [--from=<ident>] [--rfc] xxxxxxxx.patch
$ scripts/checkpatch.pl xxxxxxxx.patch
```

Use `-v` option to send new version patch.

Use `--from` option to send the patch with original author attribution.
("From:" tag will be added to the beginning of the email body. `git am` will treat the person specified with "From:" tag as the patch author.)

Use `--rfc` when sending an experimental patch for discussion rather than application.

4. Send patch

```
$ mutt -H xxxxxxxx.patch
```

5. Reply to the review

```
$ mutt -f outlook-mbox
```

Check date attribution and greetings are expected.

You can use group-reply via `g` key.

.muttrc

```
set sendmail="/usr/bin/esmtp"
set envelope_from=yes
set from="John Doe <john.doe@example.com>"
set use_from=yes
set edit_headers=yes
set hostname="example.com"
```

.esmtprc

```
identity "John Doe"
    hostname xxxxxxxx:25
    username john.doe@example.com
    password "xxxxxxxxxxxx"
```
