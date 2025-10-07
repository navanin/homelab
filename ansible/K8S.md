# Запуск
```
docker run --rm -it --mount type=bind,source="$(pwd)"/ansible/_hosts,dst=/inventory \
  --mount type=bind,source="${HOME}"/.ssh/navanin,dst=/root/.ssh/id_ed25519 \
  quay.io/kubespray/kubespray:v2.28.0 bash
ansible-playbook -i /inventory/inventory.yaml --private-key /root/.ssh/id_ed25519 -u navanin --become -K cluster.yml
```