# Laporan Proyek Expert Advisor Multi-Aset pada MetaTrader 5

Nama: ........................................  
NIM: .........................................  
Mata kuliah: .................................  
Tanggal pengujian: ...........................

## Abstrak

Proyek ini mengembangkan Expert Advisor bernama Atlas Multi-Asset EA pada platform MetaTrader 5. Sistem dirancang untuk melakukan transaksi berbasis tren dan momentum pada sepuluh instrumen yang mewakili forex, logam, indeks, aset kripto, dan energi. Pengelolaan risiko menggunakan fixed-fractional position sizing, stop-loss berbasis Average True Range, pembatas kerugian harian, dan circuit breaker berdasarkan drawdown ekuitas. Sistem tidak menerapkan martingale, grid, averaging, ataupun high-frequency trading.

Pengujian dilakukan dengan model Every tick based on real ticks selama tujuh tahun menggunakan data yang tersedia pada terminal Exness. Optimasi dilakukan pada bagian in-sample dan diverifikasi melalui forward test, pengujian penuh, serta stress test. Bagian hasil laporan ini harus diisi menggunakan keluaran asli Strategy Tester; angka yang belum diuji tidak boleh direkayasa.

## 1. Pendahuluan

### 1.1 Latar belakang

EA dapat membantu menerapkan aturan perdagangan secara konsisten, tetapi kualitasnya tidak cukup dinilai hanya dari keuntungan historis. Sistem yang layak harus memiliki aturan yang dapat diaudit, perlindungan terhadap risiko ekstrem, dan prosedur pengujian yang memisahkan proses optimasi dari validasi. Oleh sebab itu, proyek ini memadukan strategi teknikal yang relatif sederhana dengan pengelolaan risiko dan proses validasi multi-aset.

### 1.2 Tujuan

Tujuan proyek adalah menghasilkan EA MQL5 yang dapat digunakan pada beberapa kelas aset, menguji performanya selama tujuh tahun menggunakan real ticks, mengoptimalkan parameter tanpa martingale, grid, dan HFT, serta mengevaluasi kestabilan return dan drawdown pada data yang tidak digunakan selama optimasi.

## 2. Perancangan Sistem

### 2.1 Logika sinyal

Sinyal beli muncul ketika EMA cepat berada di atas EMA lambat, harga penutupan berada di atas EMA cepat, kemiringan EMA cepat naik, ADX memenuhi batas minimum, dan RSI menunjukkan momentum positif. Sinyal jual menggunakan kondisi yang berlawanan. Seluruh sinyal dievaluasi pada candle yang telah selesai untuk menghindari perubahan keputusan akibat candle yang masih berjalan.

### 2.2 Exit dan pengelolaan posisi

Stop-loss ditentukan sebagai kelipatan ATR. Take-profit dinyatakan sebagai kelipatan risiko awal atau R. Setelah posisi bergerak sesuai arah perdagangan, sistem dapat memindahkan stop-loss ke break-even dan mengaktifkan trailing stop berbasis ATR. Posisi juga dapat ditutup akibat sinyal berlawanan atau batas durasi perdagangan.

### 2.3 Pengelolaan risiko

Volume dihitung dari persentase ekuitas yang bersedia dirisikokan dan nilai kerugian satu lot dari harga masuk ke stop-loss. EA hanya mengizinkan satu posisi per simbol, membatasi jumlah trade harian, menghentikan entry setelah batas kerugian harian, dan mengaktifkan circuit breaker ketika drawdown ekuitas mencapai ambang yang ditentukan.

## 3. Data dan Metodologi Pengujian

Tuliskan versi MT5, nama server Exness, tipe akun, mata uang deposit, periode pengujian, kelengkapan data, simbol aktual, serta metode pemodelan tick. Jangan mencantumkan nomor akun, login, atau informasi rahasia.

### 3.1 Daftar instrumen

| No. | Kelas aset | Instrumen | Simbol aktual Exness | Timeframe |
|---:|---|---|---|---|
| 1 | Forex | EUR/USD | ... | H4 |
| 2 | Forex | USD/JPY | ... | H4 |
| 3 | Logam | Emas | ... | H4 |
| 4 | Logam | Perak | ... | H4 |
| 5 | Indeks | JP225 | ... | H4 |
| 6 | Indeks | US500 | ... | H4 |
| 7 | Kripto | Bitcoin | ... | H4 |
| 8 | Kripto | Ethereum | ... | H4 |
| 9 | Energi | Brent | ... | H4 |
| 10 | Energi | WTI | ... | H4 |

### 3.2 Optimasi dan validasi

Jelaskan periode in-sample, forward test, rentang parameter, optimization criterion, serta hard constraints. Lampirkan screenshot konfigurasi Strategy Tester dan tabel kandidat terbaik.

## 4. Hasil

Salin tabel dari `BACKTEST_RESULTS.csv` setelah seluruh pengujian selesai. Untuk setiap instrumen, lampirkan summary report, kurva balance/equity, drawdown, distribusi transaksi, dan performa bulanan.

### 4.1 Perbandingan sebelum dan sesudah optimasi

| Instrumen | PF awal | PF optimal | DD awal | DD optimal | Return awal | Return optimal | Forward status |
|---|---:|---:|---:|---:|---:|---:|---|
| EURUSD | ... | ... | ... | ... | ... | ... | ... |

### 4.2 Kepatuhan terhadap kriteria

| Kriteria | Batas | Hasil | Status |
|---|---:|---:|---|
| Maximum drawdown | ≤30% | ... | ... |
| Bulan rugi per tahun | ≤6 | ... | ... |
| Return bulanan rata-rata | 3–5% | ... | ... |
| Return tahunan | 50–70% | ... | ... |
| Martingale/grid/HFT | Tidak digunakan | Tidak digunakan | Lulus |

## 5. Pembahasan

Bahas instrumen yang paling stabil, perbedaan hasil antar kelas aset, perubahan performa pada forward test, sensitivitas terhadap spread dan delay, serta kemungkinan overfitting. Apabila sasaran return tidak tercapai, laporkan secara jujur dan prioritaskan kestabilan serta batas drawdown.

## 6. Kesimpulan

Tuliskan kesimpulan setelah hasil pengujian riil tersedia. Kesimpulan harus membedakan antara keberhasilan teknis EA, performa historis, dan kelayakan penggunaan ke depan.

## Lampiran

1. Kode sumber EA.
2. File preset setiap instrumen.
3. Laporan HTML Strategy Tester.
4. Hasil optimasi dan forward test.
5. Screenshot pengaturan pengujian.
6. Repository GitHub dan checksum paket penyerahan.
