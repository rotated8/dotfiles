WSL
===

I have spent hours working on issues with WSL that I probably could have avoided if I was on a full Linux installation,
but Windows has too strong a hold on me to leave. So, to prevent me from having to reinvent the wheel once I solve
something, I've put my solutions and notes here.

Links
-----

- [WSL docs](https://docs.microsoft.com/en-us/windows/wsl/about) - The interoperability and user account sections
  have been quite helpful.
- [Systemd units known to be problematic under WSL](https://github.com/arkane-systems/genie/wiki/Systemd-units-known-to-be-problematic-under-WSL) (2022) - Alternately, [Problematic Systemd Units Under WSL](https://randombytes.substack.com/p/problematic-systemd-units-under-wsl) also from 2022.

Notes
-----

`WSLInterop.conf` should be copied to `/usr/lib/binfmt.d` when you see "grep: /proc/sys/fs/binfmt\_misc/WSLInterop: No such file or directory" at login.
Then, restart WSL and the message should go away. This should only be necessary if systemd is enabled.
This solution comes from [WSL#8843](https://github.com/microsoft/WSL/issues/8843) and [systemd#28126](https://github.com/systemd/systemd/issues/28126)

MOTD had errors after a distro upgrade, which was fixed by `sudo apt remove landscape-common`, via this [AskUbuntu
thread](https://askubuntu.com/questions/1414483/landscape-sysinfo-cache-permission-denied-when-i-start-ubuntu-22-04-in-ws).

The systemd-remount-fs.service was failing, and the two links above for known problematic units suggested setting a label
on the root filesystem's device:
`findmnt -n -o SOURCE / # shows the root device is /dev/sdd.`
`sudo e2label /dev/sdd cloudimg-rootfs # sets the label.`

The systemd-networkd-wait-online.service was failing to start, leading to error messages saying a session could not be started for my user, although the network was running fine.
It seems to stem from the fact that none of the networks are managed by networkctl- they all show as unmanaged.
The best solution currently is to disable and mask the service. I got [instructions from Baeldung](https://www.baeldung.com/linux/systemd-networkd-wait-online-service-timeout-solution#bd-disable-systemd-networkd-wait-online).
