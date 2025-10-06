# Установка необходимых пакетов
brew install age sops

# Генерация age keypair
age-keygen -o age-keypair.txt

# Шифрование с помощью sops
sops -e -a <AGE_PUBLIC_KEY> test.yaml > test.enc.yaml

# Расшифровка с помощью sops
# В stdout
SOPS_AGE_KEY=<AGE_SECRET_KEY> sops <file>
# В тот же файл
SOPS_AGE_KEY=<AGE_SECRET_KEY> sops -d -i <file>
