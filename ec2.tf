resource "aws_key_pair" "ssh-gfl" {
  key_name   = "ssh-gfl-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP/DPiIPrmcjk9Kh0GxYOqnvxoi1goULR92U4V33B3KxXvYhOR/UNZq0ej4C7mfKVW7V3hWpwrY9cW7/4vpNr5kv9FHzScxt5e/GIQKFLQh9Z4N3gtMQOZinwOYRhT1Wzhj2SSmqOfV4CgQGI7UeI4IeIu4xqmHlXtC3Cf1kP6yhLKR3WY6wC1fYB/417jM14KIDKsfpD8+MguMtk9k6/83v5w/AJ8/QBfwTYnYbBskM1VV1G5VVa9bG63IItGDafWL5muHaZNFG7pwAGYYD7sZUlZDK1t6j18lXzsSqh4b1ruPfqYA5IxYBuqZRPyLmEWd2f1tKX537RDviH9CgOFgKKR8uYNaoxhrf903d+mF2xyITyZodU5oCK2myUpofugkByOddSsEphL9UAKDeYDWWYjIItAc/qqgdtQHjYFAnOPV8ZlMrl6dymvcqwiCrojh6rr3rAWugRvdwRoSRTBhFvkDn2FEJCyXBKbiPd3yzIz9VPsVmUBtBjLTzWkm5GbFfeFxzz2wxEPaUwVs5U14ZTeqlxgy8ytLDxQjSHbXzZYyNK+v6oOqJW/Q6pdOb2wTtXIlBoIr3alFC6MjltUKG6J10w1oGppJI5D2NdS9YG0YtpLBo1hxw0vCD9TqsqkxkBowxSfEjLk65dVc1JaIFY/D+xQ+E1LhS2PxCMciQ== graciafdez@gmail.com"
}

resource "aws_instance" "concourse" {
  ami                    = "ami-bbaf0ac2"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}", "${aws_security_group.docker.id}"]
  key_name               = "${aws_key_pair.ssh-gfl.key_name}"
  availability_zone      = "${aws_subnet.main.availability_zone}"

  associate_public_ip_address = true

  user_data = <<EOF
#cloud-config

# STEP 1: Creating TLS keys
write_files:
    - path: "/etc/docker/ca.pem"
      permissions: "0644"
      content: |
        -----BEGIN CERTIFICATE-----
        MIIE5jCCAs6gAwIBAgIBATANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDEwhDZXJ0
        QXV0aDAeFw0xNzExMDQxMjIwMjBaFw0xOTA1MDQxMjIwMjBaMBMxETAPBgNVBAMT
        CENlcnRBdXRoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxTtTV441
        w6sAOVyEfvyWwkOc9YxFKuCIDCBFMMEoejBCxU6kSQO9moGIA8RYcKmqert3WoTQ
        L7Lcjy/Mj+8GjOicX0/mLRA6CW1X+zrFWtrMo4mWK6PqyF9CDKJQktlPGZd0e0A5
        XWn+1SB4ir7q76V5TOdDn2xRp74Y2DP2EnCAWA+r2E7cjtL9GrdoGlXy5e/renaf
        tJ3gKv88CcigbUJ2LABxfoFZ2i4wsVU0IsQRC+lvz7IWqLp0D+XnY/x2YALOfiic
        XIJoFmkSVjNhbNwwH/Ecual07dKzVgiPmNE/r+b34VAN9yxJM3HLr7WSlo4X7RT3
        JhzDNA41V5bj/v6tHi8Ud9W5TRNuHOMEmVnRDdk2GhW+OdLqbXlP16tvQy2OKXpv
        T+QUZNbIbcumAWjtzdfQmOsmqaXNIDEtHOsOBB8swtM97ENPlDk0cwWblHY/68Yj
        osrP+o+q9glKcN2fmvSMRgm/HlddmWxI3qqHbpyGQxWfmwrOKSQm4A6/xSuSkiCA
        ByvQKIv0DpIcCtUGaGZrYaX2Psh3MiU0SgghCp6iRZqVm65hxmGLoPhErK/0HNud
        PEJrW9IIR0vK0yrVFvDoWHkvz6X1FSb/QvudxqfX2qCXMVRVFY80ylIk7gNIU7qB
        Cm4/weG4JGe1NV/ip6yM0gQomplMYKDc6sMCAwEAAaNFMEMwDgYDVR0PAQH/BAQD
        AgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFKWYYMcxEon790GRFc+R
        JdyM2If7MA0GCSqGSIb3DQEBCwUAA4ICAQCuqIzQDMXX32l7yUpAMR6siGjWNAwU
        vbJduTv0Q6Mro/JGF3rFmqM5q2rl4AaEeezlRZL3u94pThhw60aTqzUdrguwsa67
        J2ASrRUGczD4BTRFcnxa4txQq0gEizS3bdcHXiiqCd2iH3olrm32aYmVMwoVcz77
        Debg0mZdIg0BVlPAAh00MH13Ylp79w/bHH4GwPfORnJxvuURQYgajcJvSxSte2wr
        +8+ybienbufL8/SfKMq1BWs/Ftmtk1g7OVYobJE1lvrx63z9se9/FfJNDsubBnGD
        RQ5TchX2G0lQozGZbTPR2ejaSa9DWfpbChpqV+eKoC6IGCGBeS5d4Qbs2stxNFxp
        zgH8WF2rgoQJpVsclmqVsEzMowElgksfW/cj/xtUoMblNHscoQooVZ4riawErD2S
        +q3Q8cevvEz9naImRbQfE5GjiV4MHWO3FSxYfr2NTx63QR0C5x/wF0b53KCHoSHR
        1gUMnDdRnHJI+dsWOvI+QmTvdd/6tJnxzjuETcQ0oEijShmnGzn7T1yTdl331ACJ
        1J5FhGMrGq7Qa2An7UrIWfvy4OeQCmlEO3nqmCUD7Glr+l9r9MrQAwwdKCoEay3z
        T3oujJXFO+3rmYsqXQH9OWMC3xd/Gj9NQu9Gc2pXu+X4zs/cgdrl1hL0V+6nELYZ
        3PH6ioDk3CN9ag==
        -----END CERTIFICATE-----

    - path: "/etc/docker/server.pem"
      permissions: "0644"
      content: |
        -----BEGIN CERTIFICATE-----
        MIIEIDCCAgigAwIBAgIRAO9Acg49ypCrlCR7Nfh5/tkwDQYJKoZIhvcNAQELBQAw
        EzERMA8GA1UEAxMIQ2VydEF1dGgwHhcNMTcxMTA0MTIyMTQwWhcNMTkwNTA0MTIy
        MDE5WjARMQ8wDQYDVQQDEwZEb2NrZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
        ggEKAoIBAQCyVkPhNmDyUKiBUNjEHGyYr3dP2HQwboYick87DYJCXVZygJF0HYxY
        24PFtTtIeLurzZEkmGy08BkmUqhTQg+bQWtRqvBLTk0aMH90lYveoDbV1nEb8APe
        BRsL9IzUirv7QcrKjmbzSDbUMBDTVQMuFfbkvBRa0rQvKIxPdLKTtYzIYhomS0n3
        SJMnxPgQi6H2BrkkvYPlEXYVm2OAdssPgAm2HKUWwM/JWb5/1LVa8Ko1WYSMrR9C
        +USLDhoM7oF0x0mXaJU4r2ubVAKG3IxJDNcFdHOR1v00dqyxnndfnVI3Cs81IpNy
        43WpVSBdciivEEk2o1Q1+N68ojo9ReBJAgMBAAGjcTBvMA4GA1UdDwEB/wQEAwID
        uDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFBAHllT4
        3M/F0M06IpTdHnqSkynZMB8GA1UdIwQYMBaAFKWYYMcxEon790GRFc+RJdyM2If7
        MA0GCSqGSIb3DQEBCwUAA4ICAQCzRo8gfwHoE1f/OI97iGBGCB2y/JOmKkRuGI2e
        A3mBlFkuN9tFsnnk+Fc7cB0039OC8li8n3dDFZ0JwzFnbvPjR3AJCPhKA76eE4F7
        EV0QfNATeeLChH7RUsaqpenZMJsy54NVcW98irOkLJ2ToY8QlPFfaEIQqxuFCDXk
        oy1IpGxYht3Rso7uAyY2csLRMg6Ubcvw5znE5+zRKgqxUWBtUj+nvv5gJV5EPYAC
        6HvoMdsOcOMM9sav+ErLdfYhng0TgpsxkuoSf3qADT7gfPB5yIQJ6015885Is5Kp
        2Rh0Ho4X7LFfE+DdL6NM6Pdl48l92UNnALi2n/SqbCktGYDycnYt4XpyHAWi3/mS
        Wfn20X8Cy2VJPodQe0C7XG/mCQsZr60v5bMzbmLcKVknZePY9UOfD8UID8CANy78
        uTF/5opir7SJ5ALjIsG6vFtWtubhKltfQejw9BIKDTR8Io83tKMXBu+6vrZF4+bU
        xTjpUi5zgRO2j+pT4DOKKKBam4Sjv49DXWIxgPz/nzgpwj9OGrhanR+dfqz8bVbZ
        vJdqmuAkaSmSair5ISLCBoRKoovaL+IwDxACucu1kE7a8ygbupnjlVmCfKByy27E
        g0v87hmAyGnv78ukBMh4+l9cb1zoOKSTeO68h2Oj3hdkANTAKSf+kos8qKhh+lDw
        LaV15Q==
        -----END CERTIFICATE-----

    - path: "/etc/docker/server-key.pem"
      permissions: "0600"
      content: |
        -----BEGIN RSA PRIVATE KEY-----
        MIIEogIBAAKCAQEAslZD4TZg8lCogVDYxBxsmK93T9h0MG6GInJPOw2CQl1WcoCR
        dB2MWNuDxbU7SHi7q82RJJhstPAZJlKoU0IPm0FrUarwS05NGjB/dJWL3qA21dZx
        G/AD3gUbC/SM1Iq7+0HKyo5m80g21DAQ01UDLhX25LwUWtK0LyiMT3Syk7WMyGIa
        JktJ90iTJ8T4EIuh9ga5JL2D5RF2FZtjgHbLD4AJthylFsDPyVm+f9S1WvCqNVmE
        jK0fQvlEiw4aDO6BdMdJl2iVOK9rm1QChtyMSQzXBXRzkdb9NHassZ53X51SNwrP
        NSKTcuN1qVUgXXIorxBJNqNUNfjevKI6PUXgSQIDAQABAoIBAD9O0mADrty2d2sY
        qSrNMFvvhjppC64ZvjJCRBAhlok6mzKgo4IF70mn+5pW4Mm0WmL94bWNCqIczcDF
        /Q05WVLzIUbnmNAS5toSN1zKrdGFLJIywwp45NaPF2/iC5B0A5GJZJUNgkyA6T3g
        JkjvV+anU3MVtWAchmxrR4v5UF+QrmMf+guLyoMLSHykHakf0lFaHwZlAqROMY3c
        2ggA7VBTlOx1KoD2caAUPXXvbODVetsovcR6bPTHy0oEK5wxNguUsI+FlllXv86L
        316sUr1Aak8Nn+iATYGLCcteGcWg2P7GrSfWR2d3Bl84E19l1EbmwPSRkPMlhMfH
        H8mK1YECgYEA5dfTaJ6Gw/ByN8UJkUKyOsUbtIRJJOSRg6YTWRYS2odyaqhzKtFw
        zsr3dSAR92sb3aAS1V77gYPQ3QgUidIN4KvNkeJiOBvo/Dn8ub0MyuqkQRB4iEbV
        1rHUQRpVSuJuaAwIxQB8TDtcnB3T4tltz+PRBrS54Rade9+YK8BKGFECgYEAxqHg
        lK8bh173xOwsCuvDSrkEdFG2SFeKXngLNJVLSbPIaqR89Q8hj97Q4N7VCDVqFtFW
        psIetm/HvIn31wYEkws1mRIUxNg4pr9Toc1H9GiNXWSd6lLCftw+AhsAL10qtFee
        0hembfl+k6tHSd4aBxKgofi8EJ72ELqZUWTjwnkCgYBrGj5mUvDDn2jp+gQyT10U
        K8N0Q+x9p5DzQtFjQvj4IgO8FdDM1Bn4EvZq+s3EeIHcrXn5ObCDMrSCOwCvFFXp
        KsW5RD+2m7LezfqpZqHucJanxxATmMaOrAEXcTjrk0YVb/4qJsbFEyhdizywSdd0
        91jxAghYDhzGm3Oid5FPcQKBgFWPiTPCsfL/32595QLXR4o6ZEbOo9xJiRrkTr9Z
        x9J5lM0LCaBt4iEc85DJq64bhBVMGy091Qj04W6/Z3jB6NqGK5JCDZw1H0IEjDvY
        NzR6jNo76yHygEExEazKgKvmT+zbCViqQ1B/9hwZ3V1eRIvjZDog8LGgJ5JRLpW3
        BbzRAoGAQXH9ePyuhS6YoTK/hHkXawfkZXk8JSWFy4W+DP9nVQZN8RFFNCCy7ITH
        fsVbrfCTqm9We+jChpwq+GoNY5IACBT8wa39oTkTNfSJvVrv6QncAavoIUolb8qf
        PypNlv8XcWT4fccZvRcG+QlYdAAkYrda3D6+lpTQ+K7q2y6g/N0=
        -----END RSA PRIVATE KEY-----

# STEP 2: enable the secure remote API on a new socket
coreos:
  units:
    - name: docker-tls-tcp.socket
      command: start
      enable: true
      content: |
        [Unit]
        Description=Docker Secured Socket for the API

        [Socket]
        ListenStream=2376
        BindIPv6Only=both
        Service=docker.service

        [Install]
        WantedBy=sockets.target

# STEP 3: Drop-in config
    - name: docker.service
      drop-ins:
        - name: 10-tls-verify.conf
          content: |
            [Service]
            Environment="DOCKER_OPTS=--tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server.pem --tlskey=/etc/docker/server-key.pem"
EOF

  tags {
    Name = "Concourse"
  }
}
