DSD Bitrate extractor
---

Extract bitrate from DSD files, *.dsf and *.dff
- Usage: `./dsdbitrate.sh </path/file>`

### Bitrate byte number
```
----------------------------------------------------------------------------------------
|        |        bit/s        |       bash hexdump        |   php file_get_contents   |
|        |---------------------|---------------------------|---------------------------|
|        |          |          |  DSF byte#  |  DFF byte#  |  DSF byte#  |  DFF byte#  |
| DSD    |    dec   |    hex   |  5758 5960  |  6162 6364  |  5758 5960  |  6162 6364  |
----------------------------------------------------------------------------------------
| DSD64  |  2822400 | 002b1100 |  1100 002b  |  2b00 0011  |  0011 2b00  |  002b 1100  |
| DSD128 |  5644800 | 00562200 |  2200 0056  |  5600 0022  |  0022 5600  |  0056 2200  |
| DSD256 | 11289600 | 00AC4400 |  4400 00AC  |  AC00 0044  |  0044 AC00  |  00AC 4400  |
| DSD512 | 22579200 | 01588800 |  8800 0158  |  5801 0088  |  0088 5801  |  0158 8800  |
----------------------------------------------------------------------------------------
```

### DSD File Specifications
- [DSF File Format](http://dsd-guide.com/sites/default/files/white-papers/DSFFileFormatSpec_E.pdf)  
- [DSDIFF File Format](http://www.sonicstudio.com/pdf/dsd/DSDIFF_1.5_Spec.pdf)  

