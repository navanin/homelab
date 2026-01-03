# Запуск
```
docker run --rm -it --mount type=bind,source="$(pwd)"/ansible/_hosts,dst=/inventory \
  --mount type=bind,source="${HOME}"/.ssh/navanin,dst=/root/.ssh/id_ed25519 \
  quay.io/kubespray/kubespray:v2.28.0 bash
ansible-playbook -i /inventory/inventory.yaml --private-key /root/.ssh/id_ed25519 -u navanin --become -K cluster.yml
```

# Возможные проблемы

1. При запуске на базе дистрибов с включенным systemd-resolved по умолчанию, можно влететь на ошибку coredns/nodelocaldns о замеченной петле. Лечится изменением их ConfigMap'ов.
  ```
  forward . <any dns other than 127.0.0.53> {
    prefer_udp
    max_concurrent 1000
  }
  ```
2. Если захочется выбросить K8s API Gate наружу, придется прописать домен в сертификат. Делается это в конфиге kubespray k8s_cluster/k8s-cluster.yaml
   ```
   supplementary_addresses_in_ssl_keys:
     - k8s.navanin.ra1n
   ```

