# Ocupa a porta 3000, impedindo de serviços como o dev server do angular de subir
nc -lk 3000 >/dev/null
