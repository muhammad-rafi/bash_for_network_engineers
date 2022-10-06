# Generate Self-Signed Certificate using OpenSSL on Ubuntu 20.04 LTS

In this post, I will go through how to generate a self-signed certificate using open-source tool OpenSSL along with their brief explaination.

## What is Self-Signed Certificate 

Self-signed certificate is a free digital certificate that's not signed by any publicly trusted CA(certificate authority) but instead signed by creator’s own root CA certificate. Since it is signed by creater's own CA, therefore, self-signed certificates are considered unsafe for public-facing websites and applications. However, they are suitable for internal network websites, devices and development/testing environments. Self-signed certificates uses same ciphers for encrypting/decrypting data as used by paid SSL/TLS certificates.

The down side of using self-signed certificate is that, browsers or operation systems will not verify the origin of the certificate through a third-party certificate authority and will throw an invalid or untrusted issuer security warning or error. They are also prone to man-in-the-middle attacks which means, once you bypass the security warnings, you are exposed to data theft and cyberattacks.

## What is OpenSSL 

OpenSSL is a software library for applications that secure communications over computer networks against eavesdropping or need to identify the party at the other end. It is widely used by Internet servers, including the majority of HTTPS websites.

OpenSSL contains an open-source implementation of the SSL and TLS protocols. The core library, written in the C programming language, implements basic cryptographic functions and provides various utility functions. Wrappers allowing the use of the OpenSSL library in a variety of computer languages are available.

OpenSSL is available for most Unix-like operating systems (including Linux, macOS, and BSD) and Microsoft Windows.

OpenSSL is included in the default packages for Ubuntu, However, if you don't have it installed, then you can install the openssl on Ubuntu 20.04

```bash
$ sudo apt update
$ sudo apt install openssl
```

## Steps to Generate Self-Signed Certificate

To generate the self-signed certificate with openssl, we need to do the following; 

- Create your own root CA private key & CA certificate.
- Create a server private key.
- Use server private key to generate server CSR (Certificate Signing Request).
- Create self-signed SSL certificate by signing the CSR with our own root CA private key and certificate.
- Install the CA certificate in the browser or Operating system to avoid security warnings.

Before you start you can either choose to create a new directory or work on the current directory, I prefer to use new directory, so I can keep all the desired generated keys and certificates in one place. 

```bash
(main) expert@expert-cws:~$ mkdir my_certs && cd my_certs 
(main) expert@expert-cws:~/my_certs$ 
```

### Step 1: Generate a Self-Signed Root CA Key and Cert

You can create a Root CA private key with or without encryption, I have shown both methods here. I have also used two different files extensions, you can again choose either of them. 

`.pem` for both (key and cert)

or 

`.key` for CA key and `.crt` for CA cert.

__Generating root CA key and cert with aes256 encryption__

```s
openssl genrsa -aes256 -out ca-key.key 2048
openssl req -new -x509 -sha256 -days 365 -key ca-key.key -out ca-cert.crt
```

Notice the file extension are `.key` and `.crt`, however you can also use `.pem` for both key and cert.

Since you are using `-aes256` encryption, you will be prompted to enter the passphrase twice. However, to ignore the encrytion, run the first command without `-aes256` flag.

You will also be prompted to enter the details for the certificate, default exists on `/etc/ssl/openssl.cnf` location.

where;

-aes256 is an encrytion, you can also use -des3 


```bash
(main) expert@expert-cws:~/my_certs$ openssl genrsa -aes256 -out ca-key.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
...............................+++++
......................+++++
e is 65537 (0x010001)
Enter pass phrase for ca-key.key:
Verifying - Enter pass phrase for ca-key.key:
(main) expert@expert-cws:~/my_certs$ openssl req -new -x509 -sha256 -days 365 -key ca-key.key -out ca-cert.crt
Enter pass phrase for ca-key.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:UK
State or Province Name (full name) [Some-State]:England
Locality Name (eg, city) []:London
Organization Name (eg, company) [Internet Widgits Pty Ltd]:DevNetBro         
Organizational Unit Name (eg, section) []:NetOps
Common Name (e.g. server FQDN or YOUR name) []:devnetbro.com
Email Address []:admin@devnetbro.com
(main) expert@expert-cws:~/my_certs$ 
(main) expert@expert-cws:~/my_certs$ ls -l
total 16
-rw-rw-r-- 1 expert expert 1456 Oct  4 11:53 ca-cert.crt
-rw------- 1 expert expert 1766 Oct  4 11:51 ca-key.key
(main) expert@expert-cws:~/my_certs$ 
```

You can view this root CA cert by using the following command 

`openssl x509 -in ca-cert.crt -text -noout`

```bash
(main) expert@expert-cws:~/my_certs$ openssl x509 -in ca-cert.crt -text -noout
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            4e:9b:c8:a7:f9:f4:9d:70:69:ec:65:56:0e:4d:ef:4a:bd:65:9e:2f
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = UK, ST = England, L = London, O = DevNetBro, OU = NetOps, CN = devnetbro.com, emailAddress = admin@devnetbro.com
        Validity
            Not Before: Oct  4 11:53:00 2022 GMT
            Not After : Oct  4 11:53:00 2023 GMT
        Subject: C = UK, ST = England, L = London, O = DevNetBro, OU = NetOps, CN = devnetbro.com, emailAddress = admin@devnetbro.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:ba:54:e8:4f:46:b0:da:e8:ef:81:25:5f:0a:eb:
                    ac:22:b0:30:0a:6b:c0:82:7f:38:35:ba:30:4a:cd:
                    5f:da:19:79:1b:b6:1e:ad:5f:a1:72:37:b2:1f:d4:
                    42:fa:c8:36:85:98:99:d2:e2:ee:9a:c5:cb:8e:ca:
                    31:a0:c4:1b:ea:1e:73:c6:f9:f5:87:97:bd:6d:c8:
                    34:91:a2:5a:f5:e7:26:83:df:7d:68:4e:86:bb:0c:
                    c6:be:0a:a0:4c:4b:8a:9e:37:c7:4a:7f:8d:49:f5:
                    15:15:cc:a0:6e:4a:e8:3e:1a:0c:14:80:30:8a:48:
                    42:01:8a:1f:1b:a7:68:42:3a:21:09:9d:aa:a0:6b:
                    15:e1:b4:06:94:3b:d8:8a:66:f2:ce:a4:71:1b:38:
                    c0:11:01:3e:27:f0:90:0e:cc:a5:da:85:65:b0:3c:
                    bd:22:09:c9:3e:35:67:d4:42:e2:38:44:ef:7b:b5:
                    66:f0:65:6a:6b:89:47:c6:3b:32:19:0d:70:92:79:
                    09:95:05:92:57:ea:d2:11:43:bc:2c:9f:7e:7c:14:
                    16:e1:44:19:5d:16:0f:19:75:88:bb:83:13:6b:91:
                    6c:84:bc:3d:26:7d:72:72:d2:5b:6c:f5:aa:c1:6c:
                    fc:41:c5:df:e4:91:21:e9:aa:2e:82:19:5b:f4:2d:
                    12:8f
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                43:96:63:B1:E6:1B:B4:48:71:53:58:1E:BB:C7:F3:CC:91:7F:23:36
            X509v3 Authority Key Identifier: 
                keyid:43:96:63:B1:E6:1B:B4:48:71:53:58:1E:BB:C7:F3:CC:91:7F:23:36

            X509v3 Basic Constraints: critical
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
         a9:ca:c3:42:8c:03:ff:b2:84:a6:f9:ed:ad:23:c8:49:92:69:
         19:2f:d3:fe:dc:6c:07:9c:56:7d:ea:11:63:c1:31:4c:ef:f0:
         a4:31:0c:b0:9c:c5:aa:be:24:75:f7:e1:4b:33:75:c1:4a:1d:
         50:f6:47:5e:ea:6d:42:84:8a:9d:a3:d5:28:ea:da:42:f2:9d:
         66:a0:bc:3d:cf:05:b0:e7:31:dc:a2:9d:7d:a9:35:bd:4b:6b:
         74:4f:1e:40:fd:91:13:30:6c:15:ec:dc:6d:83:1e:6a:c2:51:
         e9:74:8a:da:fa:e4:12:63:17:95:e6:4c:a2:eb:2c:db:a9:88:
         0f:e6:0e:9b:ae:d6:c2:70:a6:7c:ed:74:bd:8d:09:79:e9:9e:
         93:38:f8:2d:93:56:fe:0c:3b:e1:14:6c:d8:10:f5:fe:a4:4e:
         e2:62:7f:2f:ed:90:1b:6b:8a:5b:45:22:98:f1:e5:d8:bc:15:
         6b:5f:70:19:88:93:1b:31:ff:10:50:ca:1e:39:c8:b4:7e:82:
         d5:dd:bf:58:6b:1b:d1:24:06:89:82:a5:57:fa:4d:c0:21:78:
         62:84:67:68:19:74:60:1a:c2:27:9e:70:e6:4a:4e:dd:a7:0d:
         e3:9e:30:22:d6:12:16:c5:73:b3:ef:36:82:a5:a2:27:4f:66:
         7a:04:e4:4b
(main) expert@expert-cws:~/my_certs$ 
```

Notice, `CA:TRUE` in the above output, if you don't see this, it means you haven't created the proper CA certificate and you may need to create the certificate again. 

__Generating root CA key and cert with no encryption in one-line__

You you can also generate root CA key and cert with one-line command, I have also provided the `-subj` flag, so I will not be prompted for the certificate details.

```s
openssl req -x509 -sha256 -days 356 -nodes -newkey rsa:2048 \
            -subj "/CN=devnetbro.com/C=GB/L=London/O=DevnetBro" \
            -keyout ca-key.pem -out ca-cert.pem
```

You may have also noticed that, I passed the `-nodes` flag in the above command, that will not encrypt the private key and not recommended but this is a lab environment and for the ease of this turotial I am using unencrypted key. 

```bash
(main) expert@expert-cws:~/my_certs$ openssl req -x509 -sha256 -days 356 -nodes -newkey rsa:2048 \
>             -subj "/CN=devnetbro.com/C=GB/L=London/O=DevnetBro" \
>             -keyout ca-key.pem -out ca-cert.pem 
Generating a RSA private key
..............................................................................+++++
.......................................................................................+++++
writing new private key to 'ca-key.pem'
-----
(main) expert@expert-cws:~/my_certs$ ls -l
total 8
-rw-rw-r-- 1 expert expert 1261 Oct  4 11:44 ca-cert.pem
-rw------- 1 expert expert 1704 Oct  4 11:44 ca-key.pem
(main) expert@expert-cws:~/my_certs$ 
```

You can also view your Root CA certificate in human readable format by using following command.

`openssl x509 -in ca-cert.pem -text -noout`

```bash
(main) expert@expert-cws:~/my_certs$ openssl x509 -in ca-cert.pem -text -noout
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            42:af:d9:73:56:79:8c:48:9c:1a:79:2a:58:b5:df:d7:26:1b:b5:98
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = devnetbro.com, C = GB, L = London, O = DevnetBro
        Validity
            Not Before: Oct  4 11:44:34 2022 GMT
            Not After : Sep 25 11:44:34 2023 GMT
        Subject: CN = devnetbro.com, C = GB, L = London, O = DevnetBro
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:a6:24:36:08:ed:54:3c:be:cf:23:d2:e3:4d:b9:
                    62:81:da:62:7e:e3:22:0f:8d:d3:bb:5c:0e:a0:de:
                    83:c0:f3:47:44:7c:6e:66:3d:c5:6c:06:54:e5:16:
                    ab:b3:95:c0:71:aa:d9:9e:f5:66:9e:18:f0:7a:1f:
                    8d:b1:8b:a2:61:d2:72:cf:62:0f:73:63:e2:8d:7c:
                    05:84:d6:30:b9:15:32:41:16:72:79:68:42:d6:79:
                    b4:c2:c4:d4:7e:d6:b6:c0:c1:85:02:2e:df:34:b4:
                    ee:d7:40:75:6f:c8:96:67:a1:26:2c:25:32:c0:b0:
                    5a:ae:88:da:37:4f:6f:6f:0c:0d:ed:72:be:d8:f5:
                    b1:b9:67:cd:e1:9f:09:3a:40:07:77:62:c0:39:fb:
                    bb:fe:d4:db:e2:c2:5b:aa:a7:91:a1:d7:f1:31:30:
                    ae:5d:bf:2b:cc:ec:f2:cf:3a:42:bb:4b:a0:60:54:
                    22:db:38:45:f2:0b:26:7c:87:e5:a6:46:1c:d6:c1:
                    93:d4:90:fb:0d:5f:58:0b:fd:df:18:03:72:d9:7c:
                    4e:b9:c0:dc:0e:b8:b8:f6:39:a7:9b:24:98:c2:64:
                    56:f2:8e:5d:03:84:e5:86:ad:c8:d1:76:28:65:de:
                    e5:7b:e7:73:90:37:e1:69:41:6b:cc:86:59:2b:d5:
                    e7:91
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                45:DB:86:4E:C3:78:AA:75:14:69:52:3C:F7:B3:1C:DF:A5:E8:D5:91
            X509v3 Authority Key Identifier: 
                keyid:45:DB:86:4E:C3:78:AA:75:14:69:52:3C:F7:B3:1C:DF:A5:E8:D5:91

            X509v3 Basic Constraints: critical
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
         4f:a5:1c:1a:f1:af:c2:50:a2:77:f9:af:d8:b3:3c:24:65:8b:
         b7:87:6f:7a:7f:34:44:4a:54:54:22:47:f5:34:2f:75:bb:2e:
         15:01:00:88:43:bd:9e:05:e1:44:83:7d:b6:71:07:86:01:ee:
         b9:1c:a9:f2:15:5e:db:b8:90:af:c5:45:e8:e3:51:bc:1f:38:
         05:de:02:30:64:af:d0:cb:ee:d9:6b:cd:fb:fe:35:8f:64:88:
         12:80:f1:cb:73:62:e7:e3:40:81:1d:fb:51:e8:6a:f6:ed:2b:
         34:53:88:3e:16:0c:c9:fc:c4:b5:fe:fe:77:3d:4f:bd:8e:62:
         af:27:c7:7c:85:89:d8:92:71:40:e5:57:24:69:40:f1:ae:e4:
         52:f9:f9:8f:f9:d2:e4:0f:0c:1d:21:d0:bd:56:ef:b6:9f:d5:
         45:01:e4:40:7f:b7:8a:f8:f4:d5:4d:a4:83:7d:2f:57:2e:c3:
         e2:ca:7c:fc:94:ed:e3:02:53:5c:aa:bb:e3:6d:e7:a3:fd:05:
         64:a2:72:75:2a:8e:bd:a1:c3:af:2a:e4:34:26:20:0a:39:a2:
         08:87:c1:25:ab:ea:68:db:cc:d5:86:d0:64:2d:15:44:25:dd:
         85:4c:48:e3:2a:bc:48:b3:7f:f5:14:08:54:09:cb:fd:df:cb:
         fa:79:38:96
(main) expert@expert-cws:~/my_certs$ 
```

### Step 2: Generate a Server key and Certificate Signing Request (CSR)

Next step to generate server certifcate signing request. I am going to name the private key file as server.key, but you can choose any name for this key which makes more sense for the server you are going to use this certificate for. 

__Generate a Server Private Key__

`openssl genrsa -des3 -out server.key 2048`

To ignore encryption, remove `-des3` flag 

`openssl genrsa -out server.key 2048`

__Generate Certificate Signing Request (CSR) Using above Server Private Key__

`openssl req -key server.key -new -out server.csr`

To avoid the prompt, run the following command, make sure you have correct CN is being used here, I am using for the localhost. 

`openssl req -new -sha256 -subj "/CN=localhost" -key server.key -out server.csr`

__Generate Server Private Key and Certificate Signing Request (CSR) in one-line__

Again, like above we used one-line command to generate Root CA private key and cert, we can also create server private key and csr in one line. 

`openssl req -newkey rsa:2048 -sha256 -nodes -keyout server.key -out server.csr`

```bash
(main) expert@expert-cws:~/my_certs$ openssl req -newkey rsa:2048 -sha256 -nodes -keyout server.key -out server.csr
Generating a RSA private key
.+++++
........................................................+++++
writing new private key to 'server.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:UK
State or Province Name (full name) [Some-State]:England
Locality Name (eg, city) []:London
Organization Name (eg, company) [Internet Widgits Pty Ltd]:DevNetBro
Organizational Unit Name (eg, section) []:NetOps
Common Name (e.g. server FQDN or YOUR name) []:localhost
Email Address []:admin@localhost

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
(main) expert@expert-cws:~/my_certs$ 
```

You can also create config file to generate CSR with this one-line command by passing the `-config` flag.

```bash
$ cat > server-csr.conf <<EOF
[req]
distinguished_name = req_distinguished_name
prompt = no
default_bits = 2048
default_md = sha256

[req_distinguished_name]
countryName                 = GB
stateOrProvinceName         = England
localityName                = London
organizationName            = DevNetBro
commonName                  = localhost

EOF
```

`openssl req -newkey rsa:2048 -sha256 -nodes -keyout server.key -out server.csr -config server-csr.conf`

```bash
(main) expert@expert-cws:~/my_certs$ cat > server-csr.conf <<EOF
> [req]
> distinguished_name = req_distinguished_name
> prompt = no
> default_bits = 2048
> default_md = sha256
> 
> [req_distinguished_name]
> countryName                 = GB
> stateOrProvinceName         = England
> localityName                = London
> organizationName            = DevNetBro
> commonName                  = localhost
> 
> EOF
(main) expert@expert-cws:~/my_certs$ openssl req -newkey rsa:2048 -sha256 -nodes -keyout server.key -out server.csr -config server-csr.conf
Generating a RSA private key
..+++++
......................+++++
writing new private key to 'server.key'
-----
(main) expert@expert-cws:~/my_certs$ 
```

After this step, you will see the following keys and certs are created in your current directory.

```bash
(main) expert@expert-cws:~/my_certs$ ls -l
total 20
-rw-rw-r-- 1 expert expert 1261 Oct  4 11:44 ca-cert.pem
-rw------- 1 expert expert 1704 Oct  4 11:44 ca-key.pem
-rw-rw-r-- 1 expert expert  985 Oct  4 12:06 server.csr
-rw-rw-r-- 1 expert expert  317 Oct  4 12:05 server-csr.conf
-rw------- 1 expert expert 1704 Oct  4 12:06 server.key
(main) expert@expert-cws:~/my_certs$ 
```

You can also view server CSR in human readable format by using following commands 

`openssl req -in server.csr -text -noout`

```bash
(main) expert@expert-cws:~/my_certs$ openssl req -in server.csr -text -noout
Certificate Request:
    Data:
        Version: 1 (0x0)
        Subject: C = GB, ST = England, L = London, O = DevNetBro, CN = localhost
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:c0:51:b8:60:be:7a:f8:19:fd:f3:dd:97:da:29:
                    f2:0d:3f:c1:35:02:d2:4c:0e:43:17:dd:9a:d3:d8:
                    c4:91:57:a7:3c:72:47:fe:02:68:b0:90:b0:7b:68:
                    98:b2:a3:20:0d:57:50:ef:1e:34:1d:7c:e0:87:02:
                    c5:af:52:82:68:a1:16:45:d3:12:89:48:7d:68:4a:
                    4f:3f:8c:cc:f9:1a:b2:3f:ee:48:75:31:ff:a7:4e:
                    f0:03:e3:0b:5b:f8:51:78:b2:07:39:b2:bc:2d:b6:
                    af:d1:8d:12:09:2e:22:72:56:46:84:b4:23:99:75:
                    f3:b9:df:b3:03:2c:a5:d3:ab:0c:80:e2:ed:7f:5d:
                    52:4e:e7:57:20:b6:c3:40:30:fa:c9:03:a1:eb:16:
                    b8:a3:47:3e:ea:b6:6d:c4:fb:6e:3e:2e:a3:7f:9c:
                    0d:56:da:e8:f4:34:42:d6:b1:ee:d2:73:a2:6f:d3:
                    70:88:fb:f4:e5:18:74:61:41:f6:3d:2c:f6:49:11:
                    dc:b7:b3:68:37:e7:36:d0:31:17:6d:29:1d:76:1b:
                    a4:ce:7d:b2:fc:88:08:bf:e1:d8:2c:e1:b2:40:3e:
                    04:f5:bc:8b:81:e6:d2:8f:85:97:84:b3:5a:ba:e5:
                    92:ec:54:b5:e8:0b:d0:cc:56:c5:62:0c:23:27:2e:
                    15:11
                Exponent: 65537 (0x10001)
        Attributes:
            a0:00
    Signature Algorithm: sha256WithRSAEncryption
         61:b1:e0:68:8d:67:9a:5f:f5:00:93:94:96:85:fa:23:7a:49:
         2e:7a:9c:5c:42:4f:c7:e2:2c:00:3e:61:79:d9:5a:7f:ab:a3:
         e8:07:b0:4e:db:11:a2:4e:d8:0f:98:ad:4e:62:7c:ef:d6:7b:
         10:89:69:db:ff:e6:b0:9a:50:ae:75:22:83:95:cc:b0:5b:09:
         02:f0:7f:60:24:f4:84:41:2e:86:2a:50:8d:a2:ce:f8:73:d3:
         f2:71:71:0e:ea:05:c6:69:14:08:7a:e8:f7:19:86:34:f4:2e:
         fd:3a:eb:61:61:87:eb:06:41:65:50:15:8e:40:f4:38:63:3e:
         f2:ea:ab:15:04:2c:3b:5a:fa:3e:c7:cc:fb:5f:35:d9:1b:5a:
         f2:71:d1:6f:e8:a0:ac:b1:65:1a:c4:72:c4:26:28:9b:04:40:
         96:d3:30:90:2e:f5:8b:08:a9:b8:0b:0e:3c:e8:37:3a:ab:36:
         ce:a1:37:2f:e6:d8:71:83:52:02:b1:52:83:29:72:d8:11:0f:
         de:4e:73:11:9e:f7:94:8f:fa:30:f1:49:48:2d:c7:7f:df:c4:
         ac:ab:94:d9:99:b0:46:29:e5:f6:49:e4:8b:9f:be:4e:2d:8f:
         99:ba:da:f4:50:95:a7:c9:98:ef:df:eb:79:32:97:f2:92:2c:
         77:27:33:bb
(main) expert@expert-cws:~/my_certs$ 
```

### Step 3: Generate server self-signed SSL certificate signed by own Certificate Authority

Now at this stage, we have root CA private key and cert as well as server CSR ready, next step is to sign this CSR with our own root CA private key and certificate. 

Let's firt create a `extfile.cnf` file 

```bash
$ cat > extfile.cnf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
IP.1  = 127.0.0.1

EOF
```

“DNS.1” and "IP.1" fields should be the correct domain name and IP address of your website respectively. In my case, I am using for the `localhost` host, which also resolves to `127.0.0.1`.

```s
$ openssl x509 -req -CA ca-cert.pem -CAkey ca-key.pem \
        -in server.csr -out server-cert.crt -sha256 -days 3650 \
        -CAcreateserial -extfile extfile.cnf
```

```bash
(main) expert@expert-cws:~/my_certs$ cat > extfile.cnf <<EOF
> 
> authorityKeyIdentifier=keyid,issuer
> basicConstraints=CA:FALSE
> keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
> subjectAltName = @alt_names
> 
> [alt_names]
> DNS.1 = localhost
> IP.1  = 127.0.0.1
> 
> EOF
```

```bash
(main) expert@expert-cws:~/my_certs$ openssl x509 -req -CA ca-cert.pem -CAkey ca-key.pem \
>         -in server.csr -out server-cert.crt -sha256 -days 365 \
>         -CAcreateserial -extfile extfile.cnf
Signature ok
subject=C = GB, ST = England, L = London, O = DevNetBro, CN = localhost
Getting CA Private Key
(main) expert@expert-cws:~/my_certs$
```

Finally you can see following files are created in your current directory

```bash
(main) expert@expert-cws:~/my_certs$ ls -l
total 32
-rw-rw-r-- 1 expert expert 1261 Oct  4 11:44 ca-cert.pem
-rw-rw-r-- 1 expert expert   41 Oct  4 12:26 ca-cert.srl
-rw------- 1 expert expert 1704 Oct  4 11:44 ca-key.pem
-rw-rw-r-- 1 expert expert  220 Oct  4 12:17 extfile.cnf
-rw-rw-r-- 1 expert expert 1285 Oct  4 12:26 server-cert.crt
-rw-rw-r-- 1 expert expert  985 Oct  4 12:06 server.csr
-rw-rw-r-- 1 expert expert  317 Oct  4 12:05 server-csr.conf
-rw------- 1 expert expert 1704 Oct  4 12:06 server.key
(main) expert@expert-cws:~/my_certs$ 
```

Where `server-cert.crt` is the self-signed certifcate you can use for the website, you are creating, in my case I only generate this certificate for the `localhost`.

You can again also view this certificate in human readable format. 

`openssl x509 -text -noout -in server-cert.crt`

```bash
(main) expert@expert-cws:~/my_certs$ openssl x509 -text -noout -in server-cert.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            2a:e0:e6:a0:bc:29:91:36:f8:79:69:04:f0:1b:89:69:52:bb:12:f4
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = devnetbro.com, C = GB, L = London, O = DevnetBro
        Validity
            Not Before: Oct  4 12:26:35 2022 GMT
            Not After : Oct  4 12:26:35 2023 GMT
        Subject: C = GB, ST = England, L = London, O = DevNetBro, CN = localhost
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:c0:51:b8:60:be:7a:f8:19:fd:f3:dd:97:da:29:
                    f2:0d:3f:c1:35:02:d2:4c:0e:43:17:dd:9a:d3:d8:
                    c4:91:57:a7:3c:72:47:fe:02:68:b0:90:b0:7b:68:
                    98:b2:a3:20:0d:57:50:ef:1e:34:1d:7c:e0:87:02:
                    c5:af:52:82:68:a1:16:45:d3:12:89:48:7d:68:4a:
                    4f:3f:8c:cc:f9:1a:b2:3f:ee:48:75:31:ff:a7:4e:
                    f0:03:e3:0b:5b:f8:51:78:b2:07:39:b2:bc:2d:b6:
                    af:d1:8d:12:09:2e:22:72:56:46:84:b4:23:99:75:
                    f3:b9:df:b3:03:2c:a5:d3:ab:0c:80:e2:ed:7f:5d:
                    52:4e:e7:57:20:b6:c3:40:30:fa:c9:03:a1:eb:16:
                    b8:a3:47:3e:ea:b6:6d:c4:fb:6e:3e:2e:a3:7f:9c:
                    0d:56:da:e8:f4:34:42:d6:b1:ee:d2:73:a2:6f:d3:
                    70:88:fb:f4:e5:18:74:61:41:f6:3d:2c:f6:49:11:
                    dc:b7:b3:68:37:e7:36:d0:31:17:6d:29:1d:76:1b:
                    a4:ce:7d:b2:fc:88:08:bf:e1:d8:2c:e1:b2:40:3e:
                    04:f5:bc:8b:81:e6:d2:8f:85:97:84:b3:5a:ba:e5:
                    92:ec:54:b5:e8:0b:d0:cc:56:c5:62:0c:23:27:2e:
                    15:11
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Authority Key Identifier: 
                keyid:45:DB:86:4E:C3:78:AA:75:14:69:52:3C:F7:B3:1C:DF:A5:E8:D5:91

            X509v3 Basic Constraints: 
                CA:FALSE
            X509v3 Key Usage: 
                Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment
            X509v3 Subject Alternative Name: 
                DNS:localhost, IP Address:127.0.0.1
    Signature Algorithm: sha256WithRSAEncryption
         02:9b:7a:36:f1:e5:ad:06:c0:74:69:22:cb:71:d4:ad:51:9d:
         2c:7b:e3:08:70:f1:73:09:5c:f6:2e:00:4a:ec:6b:ab:f5:8d:
         da:71:52:54:9f:b8:ae:a7:df:d4:22:85:b9:a2:39:89:c5:2d:
         52:55:5d:0f:e9:98:b3:da:23:cb:74:01:0e:7c:cd:68:99:7a:
         41:fd:69:52:48:77:76:6d:dc:15:18:67:bb:de:92:2c:aa:0b:
         79:7b:c0:3e:b5:ec:a5:a1:7a:83:bd:30:2f:15:ed:20:b6:0a:
         80:29:9b:a3:28:05:b0:25:69:53:38:20:8a:e1:5c:ff:b8:df:
         df:a0:93:1b:52:1e:7c:33:ac:5c:78:57:1d:03:82:33:db:b2:
         a3:c9:67:b9:69:74:1c:1d:73:16:5d:f1:ca:46:08:97:33:16:
         0d:a0:e0:3f:e0:68:fc:1a:01:b1:38:aa:6f:ee:a1:c2:d0:0d:
         15:9f:74:f3:17:f0:c8:5e:58:b3:18:01:34:47:bd:43:6d:ec:
         61:de:9b:5a:8c:dc:61:2a:02:90:c8:b2:d3:8e:54:55:19:2d:
         ee:f7:74:e6:26:f7:89:96:73:de:05:01:c8:19:31:89:35:3e:
         82:f5:36:54:d7:83:30:79:f1:5e:97:a7:cb:a6:b6:44:e5:7a:
         a9:d8:c4:ba
(main) expert@expert-cws:~/my_certs$ 
```

You can also verify this new `server-cert.crt` with the root CA cert file 

`openssl verify -CAfile ca-cert.pem -verbose server-cert.crt`

```bash
(main) expert@expert-cws:~/my_certs$ openssl verify -CAfile ca-cert.pem -verbose server-cert.crt
server-cert.crt: OK
(main) expert@expert-cws:~/my_certs$ 
```

Normally "X.509" Certificates exist in Base64 Formats PEM (.pem, .crt, .ca-bundle), PKCS#7 (.p7b, p7s) and Binary Formats DER (.der, .cer), PKCS#12 (.pfx, p12). However you can convert them to in to other formats. 

__Convert CRT to DER__

`openssl x509 -outform der -in server-cert.crt -out server-cert.der`

__Convert PEM to DER__

`openssl x509 -outform der -in server-cert.pem -out server-cert.der`

__Convert DER to PEM__

`openssl x509 -inform der -in server-cert.der -out server-cert.pem`

__Convert PFX to PEM__

`openssl pkcs12 -in server-cert.pfx -out server-cert.pem -nodes`

__Convert PEM to PKCS12__

`openssl pkcs12 -inkey server-key.key -in server-cert.crt -export -out server-cert.pfx`

Some useful terms in cryptogrphy and their abbrivations. 

|       Terms       |           Abbreviations
|-------------------| ----------------------------------- | 
| CA                | Certificate Authority               |
| CSR               | Certificate Signing Request         |
| AES               | Advanced Encryption Standard        | 
| DES               | Data Encryption Standard            | 
| 3DES              | Triple Data Encryption Standard     | 
| PKCS              | Public-Key Cryptography Standard    | 
| PFX               | Personal Exchange Format            |
| PEM               | Privacy-Enhanced Mail               |
| BER               | Basic Encoding Rules                |
| DER               | Distinguished Encoding Rules        |
| CER               | Canonical Encoding Rules            |
| RSA               | Riven-Shamir-Adlemen                | 
| ECC               | Elliptic Curve Cryptography         |
| MD5               | Message Digest Algorithm            | 
| SHA-1             | Secure Hash Algorithm               | 


## References:

_https://github.com/xcad2k/cheat-sheets/blob/main/misc/ssl-certs.md_

_https://github.com/jeremycohoe/cisco-ios-xe-mdt/blob/master/c9300-grpc-tls-lab.md_

_https://dev.to/techschoolguru/how-to-secure-grpc-connection-with-ssl-tls-in-go-4ph_

_https://devopscube.com/create-self-signed-certificates-openssl/_

_https://www.baeldung.com/openssl-self-signed-cert_

_https://thesecmaster.com/how-to-set-up-a-certificate-authority-on-ubuntu-using-openssl/_

_https://stackoverflow.com/questions/10175812/how-to-generate-a-self-signed-ssl-certificate-using-openssl_

_https://en.wikipedia.org/wiki/OpenSSL_

_https://www.openssl.org/_
