#!/bin/bash

# Konfigurasi mining
POOL="138.197.153.9:443"
WALLET="SaLvs8BNDCd93xtBQgeRe9bUUpNAp5SN2JbGtHZEvASL3nzbrFQ72jv45B6WxNydgmEfuMfaxhLUjMap92RjxGKa7p41h81joBy"
WORKER="4jam"
CPU_THREADS=3
DURATION=3480  # Waktu mining per sesi dalam detik (58 menit)
PAUSE=300      # Jeda antar sesi dalam detik (5 menit)

# Pastikan screen terinstal
if ! command -v screen &> /dev/null
then
    echo "screen tidak ditemukan! Instal dengan: sudo apt install screen"
    exit 1
fi

# Cek apakah direktori xmrig ada
if [ ! -f "./xmrig" ]; then
    echo "XMRig tidak ditemukan! Pastikan sudah diekstrak di folder ./xmrig"
    exit 1
fi

# Loop untuk 4 sesi mining
for i in {1..4}
do
    echo "Memulai sesi ke-$i"

    # Jalankan mining di dalam screen
    screen -dmS github ./xmrig -o $POOL -u $WALLET -p $WORKER -t $CPU_THREADS

    echo "Menambang selama $DURATION detik..."
    sleep $DURATION

    # Hentikan mining setelah 5 menit
    echo "Menghentikan sesi ke-$i"
    pkill xmrig

    # Jeda sebelum sesi berikutnya
    if [ $i -lt 4 ]; then
        echo "Jeda selama $PAUSE detik sebelum sesi berikutnya..."
        sleep $PAUSE
    fi
done

echo "Semua sesi mining selesai."
