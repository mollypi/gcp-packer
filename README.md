# packer-gcp

## building images 
```bash
$ packer build \
    -var 'bar=foo' \
    -var 'stuff=otherstuff' \
    template.json
```