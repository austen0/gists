For modern memory capacities (8GB+), swap file should be RAM+sqrt(RAM) the size. This
example assumes 16GB.

**Create the swap file and enable it:**
```sh
sudo dd if=/dev/zero of=/swapfile bs=1M count=20000 status=progress \
    && sudo chmod 600 /swapfile \
    && sudo mkswap /swapfile \
    && sudo swapon /swapfile
```

**Update swapfile fstab:**
```sh
echo "/swapfile none swap defaults 0 0" | sudo tee --append /etc/fstab
```

**Add `resume` to init hooks after `udev`:**
```sh
sudo sed -i 's/\(HOOKS="[^"]*udev \)\(.*\)$/\1resume \2/' /etc/mkinitcpio.conf \
    && sudo mkinitcpio -P
```

**Add `resume` kernel parameters to grub config:**
```sh
SWAPDEV=$(findmnt -no UUID -T /swapfile) \
    && SWAPOFFSET=$(sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}') \
    && sudo sed -i "s/\(GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*\)\(\"\)$/\1 resume=UUID=${SWAPDEV} resume_offset=${SWAPOFFSET}\2/" /etc/default/grub \
    && sudo update-grub
```

**Reduce swappiness:**
```sh
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
```
