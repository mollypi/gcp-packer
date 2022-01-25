# packer-gcp

[![Git](https://app.soluble.cloud/api/v1/public/badges/616bdc16-addc-4868-bc13-18f5b90af5a1.svg?orgId=561911742905)](https://app.soluble.cloud/repos/details/github.com/mollypi/gcp-packer?orgId=561911742905)  

## building images 
```bash
$ packer build \
    -var 'bar=foo' \
    -var 'stuff=otherstuff' \
    template.json
```