CREATE DATABASE data_perusahaan;

USE data_perusahaan;

    -- Tabel Perusahaan
CREATE TABLE perusahaan (
    id_p VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(45),
    alamat VARCHAR (45)
    );
    
    -- Tabel Departemen
CREATE TABLE departemen (
    id_dept VARCHAR(10) PRIMARY KEY,
    nama  VARCHAR(45),
    id_p VARCHAR(10),
    manajer_nik VARCHAR(10)
    );

ALTER TABLE departemen ADD FOREIGN KEY (id_p) REFERENCES perusahaan (id_p);
ALTER TABLE departemen ADD FOREIGN KEY (manajer_nik) REFERENCES karyawan (nik);

    -- Table Karyawan
CREATE TABLE karyawan (
    nik VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(45),
    id_dept VARCHAR(10),
    sup_nik VARCHAR(10)
    );

ALTER TABLE karyawan ADD FOREIGN KEY (id_dept) REFERENCES departemen (id_dept);
ALTER TABLE karyawan ADD FOREIGN KEY (sup_nik) REFERENCES karyawan (nik);

    -- Tabel Project Detail
CREATE TABLE project_detail (
    id_proj VARCHAR(10),
    nik VARCHAR(10)
    );

ALTER TABLE project_detail ADD FOREIGN KEY (id_proj) REFERENCES project (id_proj);
ALTER TABLE project_detail ADD FOREIGN KEY (nik) REFERENCES karyawan (nik);

    -- Tabel Project
CREATE TABLE Project (
    id_proj VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(45),
    tgl_mulai DATETIME,
    tgl_selesai DATETIME,
    status TINYINT
    );

    -- SQL CRUD Perusahaan
INSERT INTO `data_perusahaan`.`perusahaan` (`id_p`, `nama`) 
VALUES ('P01', 'Kantor Pusat');
INSERT INTO `data_perusahaan`.`perusahaan` (`id_p`, `nama`) 
VALUES ('P02', 'Cabang Bekasi');

    -- SQL CRUD departemen
INSERT INTO `data_perusahaan`.`departemen` (`id_dept`, `nama`, `id_p`, `manajer_nik`) 
VALUES ('D01', 'Produksi', 'P02', 'N01');
INSERT INTO `data_perusahaan`.`departemen` (`id_dept`, `nama`, `id_p`, `manajer_nik`) 
VALUES ('D02', 'Marketing', 'P01', 'N03');
INSERT INTO `data_perusahaan`.`departemen` (`id_dept`, `nama`, `id_p`) 
VALUES ('D03', 'RnD', 'P02');
INSERT INTO `data_perusahaan`.`departemen` (`id_dept`, `nama`, `id_p`) 
VALUES ('D04', 'Logistik', 'P02');

    -- SQL CRUD karyawan
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N01', 'Ari', 'D01');
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N02', 'Dina', 'D01');
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N03', 'Rika', 'D03');
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N04', 'Ratih', 'D01');
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N05', 'Riko', 'D01');
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N06', 'Dani', 'D02');
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N07', 'Anis', 'D02');
INSERT INTO `data_perusahaan`.`karyawan` (`nik`, `nama`, `id_dept`) 
VALUES ('N08', 'Dika', 'D02');

    -- SQL CRUD Project
INSERT INTO `data_perusahaan`.`project` (`id_proj`, `nama`, `tgl_mulai`, `tgl_selesai`, `status`) 
VALUES ('PJ01', 'A', '2019-01-10', '2019-03-10', '1');
INSERT INTO `data_perusahaan`.`project` (`id_proj`, `nama`, `tgl_mulai`, `tgl_selesai`, `status`) 
VALUES ('PJ02', 'B', '2019-01-15', '2019-04-10', '1');
INSERT INTO `data_perusahaan`.`project` (`id_proj`, `nama`, `tgl_mulai`, `tgl_selesai`, `status`) 
VALUES ('PJ03', 'C', '2019-03-21', '2019-05-10', '1');

    -- SQL CRUD Project Detail
INSERT INTO project_detail
VALUE
    ('PJ01', 'N01'),
    ('PJ01', 'N02'),
    ('PJ01', 'N03'),
    ('PJ01', 'N04'),
    ('PJ01', 'N05'),
    ('PJ01', 'N07'),
    ('PJ01', 'N08'),
    ('PJ02', 'N01'),
    ('PJ02', 'N03'),
    ('PJ02', 'N05'),
    ('PJ03', 'N03'),
    ('PJ03', 'N07'),
    ('PJ03', 'N08');

SELECT * FROM perusahaan;
SELECT * FROM departemen;
SELECT * FROM karyawan;
SELECT * FROM project;
SELECT * FROM project_detail;

    -- Menampilkan Nama Manajer tiap Departemen
SELECT 
    d.nama departemen,
    k.nama manajer
FROM departemen d
LEFT JOIN karyawan k ON  k.nik=manajer_nik;
    
    -- Menampilkan Nama Supervisor tiap karyawan
SELECT 
    k.nik,
    k.nama,
    d.nama departemen,
    s.nama supervisor
FROM karyawan k
LEFT JOIN karyawan s ON s.nik=k.sup_nik
LEFT JOIN departemen d ON d.id_dept=k.id_dept;

    -- Menampilkan daftar karyawan yang bekerja pada project A
SELECT 
    k.nik,
    k.nama
FROM karyawan k
JOIN project_detail pj_d ON pj_d.nik=k.nik
JOIN project pj ON pj.id_proj=pj_d.id_proj
WHERE pj.nama = 'A';

    -- Menampilkan Departemen apa saja yang terlibat dalam tiap-tiap project
SELECT DISTINCT
    d.nama AS nama_departemen
FROM departemen d
LEFT JOIN karyawan k ON d.id_dept = k.id_dept
lEFT JOIN project_detail pd ON k.nik = k.nik
LEFT JOIN project p ON pd.id_proj = p.id_proj;

    -- Menampilkan Jumlah karyawan tiap departemen yang bekerja pada tiap-tiap project
SELECT
    p.id_proj,
    p.nama AS nama_project,
    COUNT(DISTINCT k.nik) AS jumlah_karyawan
FROM project p
JOIN project_detail pd ON p.id_proj = pd.id_proj
JOIN karyawan k ON pd.nik = k.nik
GROUP BY p.id_proj, p.nama;

    -- Menampilkan Ada berapa project yang sedang dikerjakan oleh departemen RnD. (ket: project berjalan adalah yang statusnya 1)
SELECT
    COUNT(*) AS jumlah_project
FROM project p
JOIN project_detail pd ON p.id_proj = pd.id_proj
JOIN karyawan  k ON pd.nik = k.nik
JOIN departemen d ON k.id_dept = d.id_dept
WHERE d.nama = 'RnD' AND p.status = 1;

    -- Menampilkan Berapa banyak project yang sedang dikerjakan oleh Ari
SELECT
    COUNT(*) AS jumlah_project
FROM project p
JOIN project_detail pd ON p.id_proj = pd.id_proj
JOIN karyawan  k ON pd.nik = k.nik
WHERE k.nama = 'Ari';

    -- Siapa saja yang mengerjakan projcet B
SELECT
    k.nama AS  nama_karyawan
FROM karyawan k
JOIN project_detail pd ON k.nik = pd.nik
JOIN project p ON pd.id_proj = p.id_proj
WHERE p.nama = 'B';