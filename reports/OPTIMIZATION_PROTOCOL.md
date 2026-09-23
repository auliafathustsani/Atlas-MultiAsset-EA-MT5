# Protokol Backtest dan Optimasi

## 1. Lingkungan pengujian

- Platform: MetaTrader 5 64-bit versi terbaru yang tersedia pada saat pengujian.
- Broker/data: Exness, sesuai server dan tipe akun pengguna.
- Mode: Every tick based on real ticks.
- Execution delay: gunakan `Random Delay` dan ulangi kandidat final dengan delay tetap yang konservatif.
- Deposit: 10.000 USD sebagai basis perbandingan, atau nominal lain yang sama pada seluruh run.
- Leverage tester: pilih 1:1 apabila tersedia. Karena beberapa CFD tidak dapat diperdagangkan secara praktis pada 1:1, laporkan margin usage dan jangan menyamakan pengaturan tester dengan jaminan tanpa eksposur nosional.
- Periode: tujuh tahun penuh yang tersedia sampai tanggal pengujian.
- Forward: 20% bagian akhir dari periode pengujian.

## 2. Tahapan

1. Lakukan baseline backtest dengan preset awal.
2. Lakukan optimasi genetik pada bagian in-sample.
3. Buang kandidat yang melanggar hard constraints.
4. Urutkan kandidat yang lolos menggunakan skor gabungan.
5. Uji ulang 20 kandidat teratas pada forward period.
6. Uji kandidat final pada seluruh periode tujuh tahun.
7. Lakukan stress test spread, execution delay, dan perubahan parameter ±10%.
8. Simpan laporan HTML, file `.set`, grafik equity, jurnal, dan konfigurasi tester.

## 3. Rentang parameter

| Parameter | Start | Step | Stop |
|---|---:|---:|---:|
| Fast EMA | 20 | 5 | 60 |
| Slow EMA | 100 | 20 | 240 |
| Minimum ADX | 16 | 2 | 28 |
| Long RSI minimum | 50 | 2 | 58 |
| Short RSI maximum | 42 | 2 | 50 |
| Stop ATR | 1.6 | 0.2 | 3.2 |
| Take-profit R | 1.4 | 0.2 | 3.0 |
| Trail ATR | 1.5 | 0.2 | 3.1 |

Risk per trade tidak dioptimasi bersama sinyal. Tetapkan 0,25–0,50% dan baru lakukan simulasi sizing setelah kestabilan sinyal terbukti.

## 4. Hard constraints

- Net profit harus positif.
- Maximum equity drawdown tidak lebih dari 30%.
- Profit factor minimal 1,20 pada full test dan minimal 1,05 pada forward test.
- Jumlah transaksi full test minimal 60.
- Tidak lebih dari enam bulan rugi pada setiap blok kalender 12 bulan.
- Tidak ada martingale, grid, penambahan posisi rugi, atau lebih dari satu posisi per simbol.

## 5. Sasaran, bukan jaminan

- Return bulanan rata-rata: 3–5%.
- Return tahunan: 50–70%.
- Maximum drawdown: ideal di bawah 25%, batas mutlak 30%.
- Bulan rugi: maksimum enam bulan dalam satu tahun kalender.

Sasaran return bulanan 3–5% tidak identik secara matematis dengan 50–70% per tahun pada semua pola compounding. Karena itu keduanya dilaporkan terpisah dan tidak boleh dipaksakan melalui overfitting.

## 6. Uji ketahanan

- Spread: baseline, 1,25×, dan 1,50×.
- Delay: no delay, random delay, dan fixed delay konservatif.
- Parameter: kandidat final diuji pada nilai dasar serta ±10%.
- Start-date perturbation: geser tanggal awal satu dan tiga bulan.
- Monte Carlo: randomisasi urutan trade dan slippage apabila perangkat tersedia.

Kandidat dianggap cukup stabil bila hasil tidak hanya baik pada satu kombinasi parameter dan penurunan forward performance masih dapat diterima.
