include: 
  - mysql.init

mysql-all-install:
  cmd.run:
    - name: cd /opt/mysql-5.6.23 &&  cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DSYSCONFDIR=/usr/local/mysql/etc  -DMYSQL_DATADIR=/usr/local/mysql/data -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306   -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci && make && make install 

    - require:
      - cmd: mysql-tar-manage

mysql-finish-install:
  cmd.run:
    - name:  cd /opt/mysql-5.6.23 && cp support-files/mysql.server /etc/init.d/mysqld && chmod +x  /etc/init.d/mysqld &&  mkdir -p /usr/local/mysql/etc && mkdir -p /usr/local/mysql/logs/ && mv /etc/my.cnf  /etc/my.cnf.bak
    - unless: test -f /etc/my.cnf.bak 
    - require:
      - cmd: mysql-all-install

mysql-myconf-manage:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/file/my.cnf
    - user: root
    - group: root
    - require:
      - cmd: mysql-finish-install

mysql-db-init:
  cmd.run: 
    - name: cd /usr/local/mysql &&  scripts/mysql_install_db --defaults-file=/etc/my.cnf --user=mysql  && ln -s /usr/local/mysql/bin/* /usr/bin/  && touch /tmp/mysql-db-install.lock
    - unless: test -f  /tmp/mysql-db-install.lock
    - require:
      - file: mysql-myconf-manage


