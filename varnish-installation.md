## How to install Varnish from Commandline

- [Installation](#installation)

### Installation

`` wget https://repo.varnish-cache.org/source/varnish-3.0.7.tar.gz `` Download Varnish

`` tar xvfz varnish-3.0.7.tar.gz `` Untar Varnish

`` cd varnish-3.0.7 `` Enter folder

`` sh autogen.sh `` Run autogen

`` ./configure --prefix=/varnish-3.0.7/ `` Prefixed installation path

`` make `` Run make

`` make install `` Run make install


