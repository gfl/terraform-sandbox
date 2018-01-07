data "http" "letsencrypt_ca_pem" {
  url = "https://letsencrypt.org/certs/isrgrootx1.pem.txt"
}

data "template_file" "cloud-config" {
  template = <<EOF
#cloud-config

# STEP 1: Creating TLS keys
write_files:
    - path: "/etc/docker/ca.pem"
      permissions: "0644"
      content: |
        ${indent(8,data.http.letsencrypt_ca_pem.body)}
    - path: "/etc/docker/server.pem"
      permissions: "0644"
      content: |
        ${indent(8,acme_certificate.certificate.certificate_pem)}
    - path: "/etc/docker/server-key.pem"
      permissions: "0600"
      content: |
        ${indent(8,acme_certificate.certificate.private_key_pem)}

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

}