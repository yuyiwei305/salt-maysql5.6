mysql-lib-install:
  pkg.installed:
    - names:
      - gcc
      - gcc-c++
      - kernel-devel
      - ncurses-devel
      - bison
      - cmake
      - openssl
      - openssl-devel
      - perl-Module-Install.noarch

mysql-tar-manage:
  file.managed:
    - name: /opt/mysql-5.6.23.tar.gz
    - source: salt://mysql/file/mysql-5.6.23.tar.gz
    - user: root
    - group: root
  cmd.run:
    - name: useradd -s /sbin/nologin mysql && cd /opt && tar -zxf mysql-5.6.23.tar.gz
    - require:
      - pkg: mysql-lib-install
    - unless: test -e /opt/mysql-5.6.23

