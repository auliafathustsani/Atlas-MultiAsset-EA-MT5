# Atlas Multi-Asset EA for MetaTrader 5

Atlas Multi-Asset EA merupakan Expert Advisor (EA) yang dikembangkan menggunakan bahasa MQL5 untuk platform MetaTrader 5. EA menerapkan strategi mengikuti tren dengan menggabungkan indikator Exponential Moving Average (EMA), Average Directional Index (ADX), Relative Strength Index (RSI), dan Average True Range (ATR).

Sistem dilengkapi dengan pengelolaan risiko berbasis persentase ekuitas, stop-loss dan take-profit, break-even, trailing stop, pembatas transaksi harian, serta perlindungan terhadap drawdown. EA tidak menggunakan martingale, grid, averaging, maupun high-frequency trading.

## Fitur Utama

- Penentuan arah tren menggunakan EMA cepat dan EMA lambat.
- Konfirmasi kekuatan tren menggunakan ADX.
- Konfirmasi momentum menggunakan RSI.
- Stop-loss berdasarkan nilai ATR.
- Take-profit berdasarkan rasio risiko.
- Perhitungan volume transaksi secara fixed fractional.
- Fitur break-even dan ATR trailing stop.
- Pembatasan spread dan waktu perdagangan.
- Batas jumlah transaksi harian.
- Batas kerugian harian.
- Perlindungan terhadap maximum equity drawdown.
- Satu posisi aktif pada setiap simbol.
- Mendukung pengujian pada beberapa kelas aset.

## Struktur Proyek

```text
Atlas-MultiAsset-EA-MT5/
├── MQL5/
│   ├── Experts/
│   │   └── AtlasMultiAssetEA.mq5
│   └── Include/
│       └── Atlas/
│           ├── RiskManager.mqh
│           └── TradeGuards.mqh
├── Config/
│   └── instruments.csv
├── Presets/
│   ├── EURUSD_H4.set
│   ├── USDJPY_H4.set
│   ├── XAUUSD_H4.set
│   ├── XAGUSD_H4.set
│   ├── JP225_H4.set
│   ├── US500_H4.set
│   ├── BTCUSD_H4.set
│   ├── ETHUSD_H4.set
│   ├── UKOIL_H4.set
│   └── USOIL_H4.set
├── Reports/
│   ├── LAPORAN_PROYEK.md
│   ├── BACKTEST_RESULTS.csv
│   ├── OPTIMIZATION_PROTOCOL.md
│   └── TEST_CHECKLIST.md
├── Scripts/
│   └── score_optimization.py
├── PROJECT_STATUS.md
├── LICENSE
├── .gitignore
└── README.md
```

## Komponen Proyek

### AtlasMultiAssetEA.mq5

File utama Expert Advisor yang memuat inisialisasi indikator, logika pembentukan sinyal, pengelolaan posisi, pengendalian risiko, dan fungsi pengujian.

### RiskManager.mqh

File pendukung untuk menghitung volume transaksi berdasarkan persentase risiko terhadap ekuitas, jarak stop-loss, tick value, serta ketentuan minimum dan maksimum volume dari broker.

### TradeGuards.mqh

File pendukung yang digunakan untuk memeriksa spread, sesi perdagangan, candle baru, dan ketentuan lain sebelum EA membuka posisi.

### Presets

Folder ini berisi konfigurasi awal untuk sepuluh instrumen. Preset tersebut merupakan nilai awal dan masih perlu disesuaikan berdasarkan hasil optimasi masing-masing instrumen.

### Reports

Folder ini berisi protokol optimasi, checklist pengujian, rekap hasil backtest, dan laporan ringkas proyek.

### score_optimization.py

Skrip Python tambahan yang digunakan untuk menyaring serta mengurutkan hasil optimasi yang telah diekspor dari MetaTrader 5 ke dalam format CSV. Skrip ini tidak diperlukan untuk menjalankan EA.

## Daftar Instrumen

EA dirancang untuk diuji pada sepuluh instrumen yang berasal dari lima kelas aset. Pada tahap ini, pengujian sementara baru dilakukan pada EURUSD dan USDJPY menggunakan terminal MetaQuotes-Demo.

| No. | Instrumen | Kelas Aset | Status |
|---:|---|---|---|
| 1 | EURUSD | Forex | Diuji sementara |
| 2 | USDJPY | Forex | Diuji sementara |
| 3 | XAUUSD | Logam | Belum diuji |
| 4 | XAGUSD | Logam | Belum diuji |
| 5 | JP225 | Indeks | Belum diuji |
| 6 | US500 | Indeks | Belum diuji |
| 7 | BTCUSD | Kripto | Belum diuji |
| 8 | ETHUSD | Kripto | Belum diuji |
| 9 | UKOIL | Energi | Belum diuji |
| 10 | USOIL | Energi | Belum diuji |

Nama simbol dapat berbeda pada setiap broker. Nama atau suffix simbol harus disesuaikan dengan simbol yang tersedia pada Market Watch dan server Exness yang digunakan.

## Kriteria Evaluasi

Kriteria yang digunakan dalam pengembangan dan pengujian EA meliputi:

- Tidak menggunakan martingale.
- Tidak menggunakan grid.
- Tidak menggunakan averaging.
- Tidak menggunakan high-frequency trading.
- Backtest dilakukan selama tujuh tahun.
- Validasi akhir menggunakan Every tick based on real ticks.
- Broker pengujian akhir menggunakan Exness.
- Akun real hanya digunakan sebagai lingkungan dan sumber data Strategy Tester.
- Target return bulanan sebesar 3–5%.
- Target return tahunan sebesar 50–70%.
- Maximum drawdown sebesar 25–30%.
- Tidak lebih dari enam bulan rugi dalam satu tahun.

Target return merupakan kriteria evaluasi dan bukan jaminan kinerja EA. Semua hasil pengujian tetap dilaporkan meskipun tidak mencapai target.

## Konfigurasi Pengujian Sementara

Pengujian sementara EURUSD dan USDJPY dilakukan menggunakan konfigurasi berikut:

| Parameter | Konfigurasi |
|---|---|
| Platform | MetaTrader 5 |
| Expert Advisor | AtlasMultiAssetEA |
| Instrumen | EURUSD dan USDJPY |
| Timeframe | H1 |
| Periode | 23 September 2019–8 September 2026 |
| Deposit awal | USD 10.000 |
| Model validasi akhir | Every tick based on real ticks |
| History quality | 100% |
| Metode optimasi | Fast genetic based algorithm |
| Kriteria optimasi | Complex Criterion max |
| Terminal pengujian | MetaQuotes-Demo |

Pengujian tersebut belum menggunakan terminal Exness. Oleh karena itu, hasil yang tersedia masih bersifat sementara dan harus diuji ulang menggunakan data, spread, komisi, swap, serta spesifikasi kontrak dari Exness.

## Tahapan Optimasi dan Validasi

Proses optimasi dan validasi dilakukan melalui tahapan berikut:

1. EA dikompilasi menggunakan MetaEditor.
2. Hasil kompilasi diperiksa hingga menunjukkan `0 errors, 0 warnings`.
3. Baseline backtest dijalankan menggunakan parameter awal.
4. Optimasi awal dilakukan menggunakan Fast genetic based algorithm.
5. Model 1 minute OHLC dapat digunakan untuk mempercepat pencarian kandidat parameter.
6. Parameter terbaik dipilih berdasarkan hasil backtest dan forward test.
7. Kandidat terpilih diuji kembali menggunakan Every tick based on real ticks.
8. Profit, profit factor, drawdown, recovery factor, Sharpe ratio, dan jumlah transaksi diperiksa.
9. Hasil akhir disimpan dalam laporan Strategy Tester.
10. Seluruh hasil dicatat pada `Reports/BACKTEST_RESULTS.csv`.

Penggunaan model 1 minute OHLC hanya ditujukan untuk proses pencarian parameter. Hasil akhir tetap harus divalidasi menggunakan Every tick based on real ticks.

## Parameter Hasil Optimasi

### EURUSD H1

| Parameter | Nilai |
|---|---:|
| Fast EMA | 60 |
| Slow EMA | 100 |
| ADX Period | 14 |
| Minimum ADX | 20 |
| RSI Period | 14 |
| Minimum RSI long | 56 |
| Maximum RSI short | 48 |
| ATR Period | 14 |
| Stop-loss ATR | 2,2 |
| Take-profit R | 2,0 |
| Risiko per transaksi | 0,5% |
| Batas transaksi per hari | 2 |

### USDJPY H1

| Parameter | Nilai |
|---|---:|
| Fast EMA | 30 |
| Slow EMA | 220 |
| ADX Period | 14 |
| Minimum ADX | 15 |
| RSI Period | 14 |
| Minimum RSI long | 52 |
| Maximum RSI short | 44 |
| ATR Period | 14 |
| Stop-loss ATR | 2,2 |
| Take-profit R | 2,0 |
| Risiko per transaksi | 0,5% |
| Batas transaksi per hari | 2 |

## Hasil Backtest Sementara

| Instrumen | Net Profit | Return 7 Tahun | Profit Factor | Max. Equity DD | Recovery Factor | Sharpe Ratio | Total Transaksi |
|---|---:|---:|---:|---:|---:|---:|---:|
| EURUSD H1 | USD 247,08 | 2,47% | 1,02 | 10,02% | 0,23 | 0,10 | 474 |
| USDJPY H1 | USD 990,36 | 9,90% | 1,09 | 11,72% | 0,83 | 0,39 | 534 |

Kedua instrumen menghasilkan net profit positif dan memiliki maximum equity drawdown di bawah batas 30%. USDJPY memberikan hasil lebih baik dibandingkan EURUSD berdasarkan net profit, profit factor, recovery factor, dan Sharpe ratio.

Meskipun demikian, profit factor kedua instrumen masih mendekati 1 sehingga keunggulan strategi belum kuat. Return yang diperoleh merupakan return untuk keseluruhan periode sekitar tujuh tahun, bukan return setiap tahun.

## Evaluasi Target

| Kriteria | Batas | Hasil Sementara | Status |
|---|---:|---:|---|
| Maximum drawdown | 25–30% | 10,02% dan 11,72% | Memenuhi |
| Return bulanan | 3–5% | Belum tercapai | Belum memenuhi |
| Return tahunan | 50–70% | Belum tercapai | Belum memenuhi |
| Bulan rugi per tahun | Maksimal 6 | Belum dihitung | Belum dinilai |
| Martingale, grid, averaging, dan HFT | Tidak digunakan | Tidak digunakan | Memenuhi |
| Pengujian 10 instrumen | 10 instrumen | 2 instrumen | Belum memenuhi |
| Broker pengujian akhir | Exness | MetaQuotes-Demo | Belum memenuhi |

## Laporan Proyek

Laporan lengkap mengenai perancangan EA, metode pengujian, optimasi, hasil, pembahasan, kesimpulan, dan lampiran tersedia pada Google Docs:

**[Laporan Pengembangan dan Pengujian Atlas Multi-Asset EA](https://docs.google.com/document/d/1TIrWp_0VWNckjZRkrZyUCGnrWec2N5R0WstIZOfRjlM/edit?usp=sharing)**


## Cara Instalasi

1. Unduh atau clone repositori ini.
2. Buka MetaTrader 5.
3. Pilih menu `File > Open Data Folder`.
4. Buka folder `MQL5`.
5. Salin `MQL5/Experts/AtlasMultiAssetEA.mq5` dari repositori ke folder `MQL5/Experts`.
6. Salin folder `MQL5/Include/Atlas` dari repositori ke folder `MQL5/Include`.
7. Buka `AtlasMultiAssetEA.mq5` menggunakan MetaEditor.
8. Tekan `F7` untuk melakukan kompilasi.
9. Pastikan hasil kompilasi menunjukkan `0 errors, 0 warnings`.
10. Buka kembali MetaTrader 5.
11. Pilih Strategy Tester.
12. Pilih `AtlasMultiAssetEA.ex5`.
13. Tentukan simbol, timeframe, periode, deposit, dan model pengujian.
14. Jalankan baseline backtest atau optimasi.

## Cara Menjalankan Skrip Optimasi

Skrip `score_optimization.py` bersifat opsional dan digunakan setelah hasil optimasi diekspor menjadi CSV.

Instal dependensi:

```bash
pip install pandas
```

Jalankan skrip:

```bash
python Scripts/score_optimization.py hasil_optimasi.csv kandidat_terbaik.csv
```

Skrip akan membantu menyaring kandidat berdasarkan profit, profit factor, drawdown, dan jumlah transaksi. Keputusan parameter akhir tetap harus mempertimbangkan hasil forward test dan kestabilan equity curve.

## Status Proyek

### Telah Selesai

- Pengembangan source code EA.
- Pemisahan kode utama dan modul pendukung.
- Kompilasi dengan hasil `0 errors, 0 warnings`.
- Baseline backtest EURUSD dan USDJPY.
- Optimasi EURUSD dan USDJPY.
- Validasi akhir EURUSD dan USDJPY menggunakan real ticks.
- Penyusunan protokol pengujian dan laporan proyek.

### Belum Selesai

- Pengujian ulang menggunakan terminal Exness.
- Verifikasi nama dan suffix simbol Exness.
- Pengujian delapan instrumen lainnya.
- Perhitungan jumlah bulan rugi setiap tahun.
- Stress test menggunakan spread dan delay berbeda.
- Penyimpanan laporan HTML Strategy Tester.
- Validasi terhadap target return bulanan dan tahunan.

## Kesimpulan

Atlas Multi-Asset EA berhasil dikembangkan dan dikompilasi dengan hasil `0 errors, 0 warnings`. EA telah menerapkan sistem sinyal, pengelolaan posisi, serta perlindungan risiko tanpa menggunakan martingale, grid, averaging, maupun high-frequency trading.

Pengujian sementara pada EURUSD dan USDJPY menghasilkan keuntungan positif dengan drawdown di bawah 30%. Namun, performanya belum memenuhi target return bulanan dan tahunan. Selain itu, pengujian baru dilakukan pada dua instrumen menggunakan MetaQuotes-Demo sehingga belum memenuhi seluruh ketentuan tugas.

EA berhasil dari sisi implementasi teknis, tetapi masih memerlukan pengujian lanjutan pada terminal Exness dan delapan instrumen lainnya sebelum dapat dinyatakan memenuhi seluruh target proyek.

## Catatan Risiko

Proyek ini dibuat untuk keperluan akademik, penelitian, dan pengembangan. Hasil backtest tidak menjamin kinerja yang sama pada masa mendatang.

Perbedaan broker, spread, komisi, swap, slippage, spesifikasi kontrak, likuiditas, dan kualitas data dapat memengaruhi hasil pengujian. Jangan menggunakan EA pada akun riil sebelum melakukan validasi yang memadai.

Jangan menyimpan nomor akun, login, password, investor password, OTP, API key, atau informasi rahasia lainnya di dalam repositori.
