--Trần Minh Triết - 51703206
--Đào Minh Nguyệt - 51704071
Use master
If exists (select * from sys.databases where name = 'VietNamIdol')
	Drop database VietNamIdol
Go
Create database VietNamIdol
Go
Use VietNamIdol
Go
--Bảng 1
If exists (select * from sys.objects where name='Nguoi')
	drop table Nguoi
Go
Create table Nguoi(
	ID varchar(12) not null, -- KHÓA CHÍNH TS[YYYY][0-9][0-9][0-9][0-9][0-9][0-9] và NS[0-9][0-9][0-9][0-9][0-9][0-9]
	CMND varchar(12) not null,
	HoTen nvarchar(50) not null,
	GioiTinh bit not null, -- 0 là Nam, 1 là Nữ.
	NgaySinh date not null, -- DD-MM-YYYY
	NoiSinh nvarchar(20) not null
)
Go
Alter table Nguoi add constraint PK_Nguoi_ID 
primary key(ID) -- Khóa chính ID
Go
Alter table Nguoi add constraint CHK_Nguoi_ID 
check((len(ID) = 12 and left(ID,2) = 'TS' and right(ID,10) 
like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') or
(len(ID) = 8 and left(ID,2) = 'NS' and right(ID,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]'))
Go
Set dateformat dmy --Cho phép nhập định dạng ngày tháng năm
Select ID,CMND,HoTen as N'Họ tên',GioiTinh as N'Giới tính',CONVERT(varchar(10), NgaySinh, 103) As N'Ngày sinh',NoiSinh as N'Nơi sinh' from Nguoi
Go
--Bảng 2
If exists (select * from sys.objects where name='ThiSinh')
	Drop table ThiSinh
Go
Create table ThiSinh(
	ID varchar(12) not null, --KHÓA CHÍNH những ID bắt đầu bằng TS
	DiaChi nvarchar(100),
	DienThoai char(10),
	GioiThieu NText
)
Go
Alter table ThiSinh add constraint PK_ThiSinh_ID 
primary key(ID) --Khóa chính
Go
Alter table ThiSinh add constraint FK_ThiSinh_ID
foreign key(ID) References Nguoi(ID) --Khóa Ngoại
Go
Alter table ThiSinh add constraint CHK_ThiSinh_ID --Check mã TS
check(len(ID) = 12 and left(ID,2) = 'TS' and right(ID,10) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bang 3
If exists (select * from sys.objects where name='NgheSi')
	Drop table NgheSi
Go
Create table NgheSi(
	ID varchar(12) not null,
	NgheDanh nvarchar(20),
	ThanhTich NText,
	MCFlag bit,	--có 2 giá trị 0 hoặc 1 dùng để xác định 
	CSFlag bit, --người nghệ sỹ đó có phải lần lượt là MC, 
	NSFlag bit	--ca sỹ, nhạc sỹ hay không
)
Go
Alter table NgheSi add constraint PK_NgheSi_ID 
primary key(ID) --Khóa chính
Go 
Alter table NgheSi add constraint FK_NgheSi_ID 
foreign key(ID) References Nguoi(ID) --Khóa ngoại
Go 
Alter table NgheSi add constraint CHK_NgheSi_ID --Check mã NS
check(len(ID) = 8 and left(ID,2) = 'NS' and right(ID,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 4
if exists (select * from sys.objects where name='ChuongTrinhMC')
	drop table ChuongTrinhMC
Go
create table ChuongTrinhMC(
	ID varchar(12) not null,
	CT_DaDan nvarchar(200) not null,
)
alter table ChuongTrinhMC add constraint PK_ChuongTrinhMC_CT_DaDan_ID 
primary key(ID,CT_DaDan)
Go --Khóa chính
alter table ChuongTrinhMC add constraint FK_ChuongTrinhMC_ID 
foreign key(ID) References NgheSi(ID) 
Go --Khóa ngoại
alter table ChuongTrinhMC add constraint CHK_ChuongTrinhMC_ID --Check mã NS
check(len(ID) = 8 and left(ID,2) = 'NS' and right(ID,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 5
if exists (select * from sys.objects where name='AlbumCaSi')
	drop table AlbumCasi
Go
create table AlbumCaSi(
	ID varchar(12) not null,
	album nvarchar(200) not null
)
Go
alter table AlbumCaSi add constraint PK_AlbumCaSi_AlBum_ID
primary key(ID,album)
Go --Khóa chính
alter table AlbumCaSi add constraint FK_AlbumCaSi_ID 
foreign key(ID) References NgheSi(ID) 
Go --Khóa ngoại
alter table AlbumCaSi add constraint CHK_AlbumCaSi_ID --Check mã NS
check(len(ID) = 8 and left(ID,2) = 'NS' and right(ID,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 6
if exists (select * from sys.objects where name='BaiHat')
	drop table BaiHat
Go
create table BaiHat(
	ID varchar(8) not null, -- BH[0-9][0-9][0-9][0-9][0-9][0-9]. Ví dụ BH000001, BH000002
	TuaBH nvarchar(200) not null
)
Go
alter table BaiHat add constraint PK_BaiHat_ID 
primary key(ID)
Go -- Khóa chính
alter table BaiHat add constraint CHK_BaiHat_ID --Check mã BH
check(len(ID) = 8 and left(ID,2) = 'BH' and right(ID,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 7
if exists (select * from sys.objects where name='TheLoai')
	drop table TheLoai
Go
create table TheLoai(
	ID varchar(5) not null,  --TL[0-9][0-9][0-9]. Ví dụ TL001, TL002
	TheLoai nvarchar(200) not null unique --Tên thể loại
)
Go
alter table TheLoai add constraint PK_TheLoai_ID
primary key(ID) --Khóa chính
Go
alter table TheLoai add constraint CHK_TheLoai_ID --Check mã TL
check(len(ID) = 5 and left(ID,2) = 'TL' and right(ID,3) like '[0-9][0-9][0-9]')
Go

--Bảng 8
if exists (select * from sys.objects where name='BaiHatThuocTheLoai')
	drop table BaiHatThuocTheLoai
Go
create table BaiHatThuocTheLoai(
	MaBaiHat varchar(8) not null,
	MaTheLoai varchar(5) not null
)
Go
alter table BaiHatThuocTheLoai add constraint PK_BaiHatThuocTheLoai_MaBaiHat_MaTheLoai
primary key(MaBaiHat,MaTheLoai) --Khóa chính
alter table BaiHatThuocTheLoai add constraint FK_BaiHatThuocTheLoai_MaBaiHat 
foreign key(MaBaiHat) References BaiHat(ID) --FK tham chiếu BaiHat(ID)
alter table BaiHatThuocTheLoai add constraint FK_BaiHatThuocTheLoai_MaTheLoai 
foreign key(MaTheLoai) References TheLoai(ID) --FK tham chiếu TheLoai(ID)
Go
alter table BaiHatThuocTheLoai add constraint CHK_BaiHatThuocTheLoai_MaTheLoai --Check mã TL
check(len(MaTheLoai) = 5 and left(MaTheLoai,2) = 'TL' and right(MaTheLoai,3) like '[0-9][0-9][0-9]')
Go
alter table BaiHatThuocTheLoai add constraint CHK_BaiHatThuocTheLoai_MaBaiHat --Check mã BH
check(len(MaBaiHat) = 8 and left(MaBaiHat,2) = 'BH' and right(MaBaiHat,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 9
if exists (select * from sys.objects where name='NhacSiSangTac')
	drop table NhacSiSangTac
Go
create table NhacSiSangTac(
	MaNhacSi varchar(12) not null,
	MaBaiHat varchar(8) not null,
	ThongTinCaSi int-- 1: sáng tác phần lời, 2: sáng tác phần nhạc, 3: cả hai (nhạc và lời)
)

alter table NhacSiSangTac add constraint PK_NhacSiSangTac_MaNhacSi_MaBaiHat 
primary key(MaNhacSi,MaBaiHat) --Khóa chính
Go
alter table NhacSiSangTac add constraint FK_NhacSiSangTac_MaNhacSi 
foreign key(MaNhacSi) references NgheSi(ID)--Khóa ngoại đến Nghệ sĩ
Go
alter table NhacSiSangTac add constraint FK_NhacSiSangTac_MaBaiHat
foreign key(MaBaiHat) references BaiHat(ID)--Khóa ngoại đến Bài Hats
Go
alter table NhacSiSangTac add constraint CHK_NhacSiSangTac_MaBaiHat --Check mã BH
check(len(MaBaiHat) = 8 and left(MaBaiHat,2) = 'BH' and right(MaBaiHat,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go
alter table NhacSiSangTac add constraint CHK_NhacSiSangTac_MaNhacSi --Check mã NS
check(len(MaNhacSi) = 8 and left(MaNhacSi,2) = 'NS' and right(MaNhacSi,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go
alter table NhacSiSangTac add constraint CHK_ThongTinCaSi  --Check thông tin
check(ThongTinCaSi In(1,2,3))
Go

--Bảng 10
if exists (select * from sys.objects where name='TinhThanh')
	drop table TinhThanh
Go
create table TinhThanh(
	ID varchar(4) not null, --TT[0-9][0-9]. Ví dụ TT01, TT02
	Ten nvarchar(20) not null unique
) 
Go
alter table TinhThanh add constraint PK_TinhThanh_ID 
primary key(ID) --Khóa chính
Go
alter table TinhThanh add constraint CHK_TinhThanh_ID 
check(len(ID) = 4 and left(ID,2) = 'TT' and right(ID,2) like '[0-9][0-9]')--Check Tỉnh thành
Go 

--Bảng 11
if exists (select * from sys.objects where name='NhaSanXuat')
	drop table NhaSanXuat
Go
create table NhaSanXuat(
	ID varchar(6) not null, --NSX[0-9][0-9][0-9]. Ví dụ: NSX001, NSX002
	Ten nvarchar(100)
)
Go
alter table NhaSanXuat add constraint PK_NhaSanXuat_ID 
primary key(ID) --Khóa chính
Go
alter table NhaSanXuat add constraint CHK_NhaSanXuat_ID  
check(len(ID) = 6 and left(ID,3) = 'NSX' and right(ID,3) like '[0-9][0-9][0-9]') --Check mã NSX
Go  

--Bảng 12
if exists (select * from sys.objects where name='KenhTruyenHinh')
	drop table KenhTruyenHinh
Go
create table KenhTruyenHinh(
	ID varchar(5) not null, -- TH[0-9][0-9][0-9]. Ví dụ: TH001, TH002
	Ten nvarchar(20) not null
)
Go
alter table KenhTruyenHinh add constraint PK_KenhTruyenHinh_ID 
primary key(ID)
Go --Khóa chính
alter table KenhTruyenHinh add constraint CHK_KenhTruyenHinh_ID  --Check kênh
check(len(ID) = 5 and left(ID,2) = 'TH' and right(ID,3) like '[0-9][0-9][0-9]') 
go 

--Bảng 13
if exists (select * from sys.objects where name='MuaThi')
	drop table MuaThi
Go
IF OBJECT_ID('Func_SetMuaThi') IS NOT NULL
   DROP FUNCTION Func_SetMuaThi
Go
Create function dbo.Func_SetMuaThi() -- Lấy ID Mùa Thi
Returns varchar(4)
As Begin
	Declare @MuaThi varchar(4)
    select @MuaThi = ConCat('MT',cast(count(*) + 1 as varchar)) From dbo.MuaThi
Return @Muathi
End
Go 
create table MuaThi(
	ID varchar(4) not null default dbo.Func_SetMuaThi(),
	NgayBD date, 
	NgayKT date,
	GiaiThuong NText,
	DiaDiemVongNhaHat nvarchar(50),
	DiaDiemVongBanKet nvarchar(50),
	DiaDiemVongGala nvarchar(50),
	MaGiamDocAmNhac varchar(12),
	MaGK1 varchar(12),
	MaGK2 varchar(12),
	MaGk3 varchar(12),
	MaMC varchar(12)
)
Go
alter table MuaThi add constraint PK_MuaThi_ID 
primary key(ID)
Go --Khóa chính
alter table MuaThi add constraint CHK_MuaThi_NgayKT 
check((year(NgayBD) <= year(NgayKT)) or (month(NgayBD) <= month(NgayKT)) and (day(NgayBD) <= day(NgayKT)))
Go --Check ngày kết thúc
alter table MuaThi add constraint CHK_MuaThi_MaGiamDocAmNhac
check(len(MaGiamDocAmNhac) = 8 and left(MaGiamDocAmNhac,2) = 'NS' and right(MaGiamDocAmNhac,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go  --Check mã NS
alter table MuaThi add constraint CHK_MuaThi_MaGK1
check(len(MaGK1) = 8 and left(MaGK1,2) = 'NS' and right(MaGK1,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go --Check mã NS
alter table MuaThi add constraint CHK_MuaThi_MaGK2
check(len(MaGK2) = 8 and left(MaGK2,2) = 'NS' and right(MaGK2,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go  --Check mã NS
alter table MuaThi add constraint CHK_MuaThi_MaGk3 
check(len(MaGk3) = 8 and left(MaGk3,2) = 'NS' and right(MaGk3,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go  --Check mã NS
alter table MuaThi add constraint CHK_MuaThi_MaMC
check(len(MaMC) = 8 and left(MaMC,2) = 'NS' and right(MaMC,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]') --Check mã NS
Go  

--Bảng 14
if exists (select * from sys.objects where name='BanQuyenMuaThi')
	drop table BanQuyenMuaThi
Go
create table BanQuyenMuaThi(
	ID varchar(4) not null,
	MaNSX varchar(6) not null
)
Go
alter table BanQuyenMuaThi add constraint PK_BanQuyenMuaThi_MaMuaThi_MaNSX 
primary key(ID, MaNSX) 
Go --Khóa chính
alter table BanQuyenMuaThi add constraint FK_BanQuyenMuaThi_MaMuaThi 
foreign key(ID) references MuaThi(ID) 
Go --Khóa ngoại đến mùa thi
alter table BanQuyenMuaThi add constraint FK_BanQuyenMuaThi_MaNSX 
foreign key(MaNSX) references NhaSanXuat(ID)
Go --Khóa ngoại đến NSX
alter table BanQuyenMuaThi add constraint CHK_BanQuyenMuaThi_MaNSX 
check(len(MaNSX) = 6 and left(MaNSX,3) = 'NSX' and right(MaNSX,3) like '[0-9][0-9][0-9]') --Check mã NSX
Go  

--Bảng 15
if exists (select * from sys.objects where name='PhatSong')
	drop table PhatSong
Go
create table PhatSong(
	MaMuaThi varchar(4) not null,
	MaKenh varchar(5) not null,
	ThongTinPS int not null --1: chỉ phát sóng vòng bán kết, 2: chỉ phát sóng vòng gala, 3: phát sóng cả hai vòng
)
Go
alter table PhatSong add constraint PK_PhatSong_MaMuaThi_MaKenh 
primary key(MaMuaThi, MaKenh)
Go --Khóa chính
alter table PhatSong add constraint FK_PhatSong_MaMuaThi 
foreign key(MaMuaThi) references MuaThi(ID)
Go --Khóa ngoại
alter table PhatSong add constraint FK_PhatSong_MaKenh 
foreign key(MaKenh) references KenhTruyenHinh(ID)
Go --Khóa ngoại
alter table PhatSong add constraint CHK_PhatSong_ThongTinPS 
check(ThongTinPS IN(1,2,3))
Go --Check thông tin phát sóng
alter table PhatSong add constraint CHK_PhatSong_MaKenh  --Check kênh
check(len(MaKenh) = 5 and left(MaKenh,2) = 'TH' and right(MaKenh,3) like '[0-9][0-9][0-9]') 
go 

--Bảng 16
if exists (select * from sys.objects where name='VongThi')
	drop table VongThi
Go
IF OBJECT_ID('Func_SetVongThi') IS NOT NULL
   DROP FUNCTION Func_SetVongThi
Go
Create function dbo.Func_SetVongThi (@MaMuaThi varchar(4)) -- Lấy STT Vòng Thi
Returns int
As Begin
Declare @STTVongThi int
    select @STTVongThi =  count(*) + 1 From dbo.VongThi where MaMuaThi = @MaMuaThi
Return @STTVongThi
End
Go 
create table VongThi(
	SttVongThi int not null,
	MaMuaThi varchar(4)  not null,
	TenVongThi NText,
	ThoiGianBD datetime,
	ThoiGianKT datetime,
	LoaiVongThi int
) 
Go
alter table VongThi add constraint PK_VongThi_STTVongThi_MaMuaThi 
primary key(SttVongThi,MaMuaThi) 
Go --Khóa chính
alter table VongThi add constraint CHK_VongThi_LoaiVongThi 
check(LoaiVongThi IN(1,2,3,4))
Go --Check Loại vòng thi
alter table VongThi add constraint CHK_VongThi_ThoiGianKT --Check ngày kết thúc
check(((year(ThoiGianBD) <= year(ThoiGianKT)) and (month(ThoiGianBD) <= month(ThoiGianKT)) and (day(ThoiGianBD) <= day(ThoiGianKT)))
and (Datepart(hour,ThoiGianBD) <= Datepart(hour,ThoiGianKT)) and (Datepart(minute,ThoiGianBD) <= Datepart(minute,ThoiGianKT)))
Go

--Bảng 17
if exists (select * from sys.objects where name='TSTGVongThi')
	drop table TSTGVongThi 
Go
create table TSTGVongThi(
	SttVongThi int not null,
	MaMuaThi varchar(4) not null,
	MaThiSinh varchar(12) not null,
	KetQua int default(-1) not null check(KetQua in(-1,0,1,2))
)
Go

alter table TSTGVongThi add constraint PK_TSTGVongThi_STT_MaMuaThi_MaThiSinh 
primary key(SttVongThi,MaMuaThi,MaThiSinh) 
Go--Khóa chính
alter table TSTGVongThi add constraint FK_TSTGVongThi_MaMuaThi 
foreign key(MaMuaThi) references MuaThi(ID)
Go --Khóa ngoại
alter table TSTGVongThi add constraint FK_TSTGVongThi_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại

--Bảng 18
if exists (select * from sys.objects where name='VongThuGiong')
	drop table VongThuGiong 
Go
create table VongThuGiong(
	STTVongThi int not null,
	MaMuaThi varchar(4) not null,
	MaTinhThanh varchar(4),
	Diadiem NText
)
Go
alter table VongThuGiong add constraint PK_VongThuGiong_SttVongThi_MaMuaThi 
primary key(sttvongthi, mamuathi) 
Go --Khóa chính
alter table VongThuGiong add constraint FK_VongThuGiong_MaTinhThanh 
foreign key(MaTinhThanh) references TinhThanh(ID) 
Go --Khóa ngoại
alter table VongThuGiong add constraint FK_VongThuGiong_SttVongThi_MaMuaThi 
foreign key(sttvongthi, mamuathi)  references VongThi(SttVongThi,MaMuaThi)
Go --Khóa ngoại
alter table VongThuGiong add constraint CHK_VongThuGiong_MaTinhThanh --Check Tỉnh thành
check(len(MaTinhThanh) = 4 and left(MaTinhThanh,2) = 'TT' and right(MaTinhThanh,2) like '[0-9][0-9]')
Go 

--Bảng 19
if exists (select * from sys.objects where name='TSTGVongThuGiong')
	drop table TSTGVongThuGiong 
Go
create table TSTGVongThuGiong(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	MaThiSinh varchar(12) not null,
	GK1vote bit,
	GK2vote bit,
	GK3vote bit
)
alter table TSTGVongThuGiong add constraint PK_TSTGVongThuGiong_STT_MaMuaThi_MaThiSinh
primary key(Sttvongthi,MaMuaThi,MaThiSinh)
Go --Khóa chính
alter table TSTGVongThuGiong add constraint FK_TTSTGVongThuGiong_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại  
alter table TSTGVongThuGiong add constraint FK_TSTGVongThuGiong_STTVongThi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongThuGiong(STTVongThi,MaMuaThi)--Khóa ngoại
Go 

--Bảng 20
if exists (select * from sys.objects where name='TSHatVongThuGiong')
	drop table TSHatVongThuGiong 
Go
create table TSHatVongThuGiong(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	MaThiSinh varchar(12) not null,
	MaBH varchar(8) not null,
)
Go
alter table TSHatVongThuGiong add constraint PK_TSHatVongThuGiong_STT_MaMuaThi_MaThiSinh_MaBH
primary key(Sttvongthi,MaMuaThi,MaThiSinh,MaBH)
Go --Khóa chính
alter table TSHatVongThuGiong add constraint FK_TSHatVongThuGiong_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại  
alter table TSHatVongThuGiong add constraint FK_TSHatVongThuGiong_STTVongthi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongThuGiong(STTVongThi,MaMuaThi)--Khóa ngoại
Go 
alter table TSHatVongThuGiong add constraint CHK_TSHatVongThuGiong_MaThiSinh --Check mã TS
check(len(MaThiSinh) = 12 and left(MaThiSinh,2) = 'TS' and right(MaThiSinh,10) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
Go
alter table TSHatVongThuGiong add constraint CHK_TSHatVongThuGiong_MaBH --Check mã BH
check(len(MaBH) = 8 and left(MaBH,2) = 'BH' and right(MaBH,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go
--Bảng 21
if exists (select * from sys.objects where name='VongNhaHat')
	drop table VongNhaHat 
Go
create table VongNhaHat(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	HatNhomFlag bit not null
)
Go
alter table VongNhaHat add constraint PK_VongNhaHat_STTVongThi_MaMuaThi
primary key(Sttvongthi,MaMuaThi)--Khóa chính
Go
alter table VongNhaHat add constraint FK_VongNhaHat_SttVongThi_MaMuaThi 
foreign key(sttvongthi, mamuathi)  references VongThi(SttVongThi,MaMuaThi)
Go --Khóa ngoại

--Bảng 22
if exists (select * from sys.objects where name='TSHatVongNhaHat')
	drop table TSHatVongNhaHat
create table TSHatVongNhaHat(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	MaThiSinh varchar(12) not null,
	MaBH varchar(8) not null,
)
Go
alter table TSHatVongNhaHat add constraint PK_TSHatVongNhaHat_STT_MaMuaThi_MaThiSinh_MaBH
primary key(Sttvongthi,MaMuaThi,MaThiSinh,MaBH)
Go --Khóa chính
alter table TSHatVongNhaHat add constraint FK_TSHatVongNhaHat_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại  
alter table TSHatVongNhaHat add constraint FK_TSHatVongNhaHat_STTVongthi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongNhaHat(STTVongThi,MaMuaThi)--Khóa ngoại
Go 
alter table TSHatVongNhaHat add constraint CHK_TSHatVongNhaHat_MaThiSinh --Check mã TS
check(len(MaThiSinh) = 12 and left(MaThiSinh,2) = 'TS' and right(MaThiSinh,10) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
Go
alter table TSHatVongNhaHat add constraint CHK_TSHatVongNhaHat_MaBH --Check mã BH
check(len(MaBH) = 8 and left(MaBH,2) = 'BH' and right(MaBH,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 23
if exists (select * from sys.objects where name='NhomCa')
	drop table NhomCa
Go
create table NhomCa(
	ID varchar(8) not null,
	TenNhom nvarchar(50),
	MaThiSinh1 varchar(12) not null unique,
	MaThiSinh2 varchar(12) not null unique,
	MaThiSinh3 varchar(12) not null unique,
	MaThiSinh4 varchar(12) not null unique
)
Go
alter table NhomCa add constraint PK_NhomCa_ID
primary key(ID) 
Go --Khóa chính
alter table NhomCa add constraint FK_NhomCa_MaThiSinh1
foreign key(MaThiSinh1) references ThiSinh(ID) 
Go --Khóa ngoại
alter table NhomCa add constraint FK_NhomCa_MaThiSinh2
foreign key(MaThiSinh2) references ThiSinh(ID) 
Go --Khóa ngoại
alter table NhomCa add constraint FK_NhomCa_MaThiSinh3
foreign key(MaThiSinh3) references ThiSinh(ID) 
Go --Khóa ngoại
alter table NhomCa add constraint FK_NhomCa_MaThiSinh4
foreign key(MaThiSinh4) references ThiSinh(ID) 
Go --Khóa ngoại
Go --Khóa chính
alter table NhomCa add constraint CHK_NhomCa_ID--Check mã nhóm ca
check(len(ID) = 8 and left(ID,2) = 'NC' and right(ID,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 24
if exists (select * from sys.objects where name='NhomCaHatBH')
	drop table NhomCaHatBH
Go
create table NhomCaHatBH(
	ID varchar(8) not null,
	MaBH varchar(8) not null,
	STTvongthi int not null,
	MaMuaThi varchar(4) not null
)
Go
alter table NhomCaHatBH add constraint PK_NhomCa_ID_MaBH
primary key(ID,MaBH)
Go --Khóa chính
alter table NhomCaHatBH add constraint FK_NhomCaHatBH_STTVongthi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongNhaHat(STTVongThi,MaMuaThi)
Go --Khóa ngoại
alter table NhomCaHatBH add constraint CHK_NhomCaHatBH_ID--Check mã nhóm ca
check(len(ID) = 8 and left(ID,2) = 'NC' and right(ID,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go
alter table NhomCaHatBH add constraint CHK_NhomCaHatBH_MaBH --Check mã BH
check(len(MaBH) = 8 and left(MaBH,2) = 'BH' and right(MaBH,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 25
if exists (select * from sys.objects where name='VongBanKet')
	drop table VongBanKet
Go
create table VongBanKet(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	Nam_Nu int default(-1) check(Nam_Nu in(-1,0,1))
)
Go
alter table VongBanKet add constraint PK_VongBanKet_STTVongThi_MaMuaThi
primary key(Sttvongthi,MaMuaThi)--Khóa chính
Go
alter table VongBanKet add constraint FK_VongBanKet_SttVongThi_MaMuaThi 
foreign key(sttvongthi, mamuathi)  references VongThi(SttVongThi,MaMuaThi)
Go --Khóa ngoại

--Bảng 26
if exists (select * from sys.objects where name='TSTGVongBanKet')
	drop table TSTGVongBanKet
Go
create table TSTGVongBanKet(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	MaThiSinh varchar(12) not null,
	MSBC varchar(4), --độ dài 4 và [0-9][0-9][0-9][0-9]
	TongSoTN int
)
alter table TSTGVongBanKet add constraint PK_TSTGVongBanKet_STTVongThi_MaMuaThi_MaThiSinh
primary key(Sttvongthi,MaMuaThi,MaThiSinh)
Go --Khóa chính
alter table TSTGVongBanKet add constraint FK_TSTGVongBanKet_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại  
alter table TSTGVongBanKet add constraint FK_TSTGVongBanKet_STTVongThi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongBanKet(STTVongThi,MaMuaThi)--Khóa ngoại
Go 
alter table TSTGVongBanKet add constraint CHK_TSTGVongBanKet_MSBC --Check mã MSBC
check(len(MSBC) = 4 and left(MSBC,2) = 'BC' and right(MSBC,2) like '[0-9][0-9]')
Go

--Bảng 27
if exists (select * from sys.objects where name='TSHatVongBanKet')
	drop table TSHatVongBanKet
Go
create table TSHatVongBanKet(
	MaThiSinh varchar(12) not null,
	MaBH varchar(8) not null unique,
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
)
Go
alter table TSHatVongBanKet add constraint PK_TSHatVongBanKet_MaThiSinh_MaBH
primary key(MaThiSinh,MaBH)
Go --Khóa chính
alter table TSHatVongBanKet add constraint FK_TSHatVongBanKet_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại  
alter table TSHatVongBanKet add constraint FK_TSHatVongBanKet_STTVongthi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongBanKet(STTVongThi,MaMuaThi)--Khóa ngoại
Go 
alter table TSHatVongBanKet add constraint CHK_TSHatVongBanKet_MaThiSinh --Check mã TS
check(len(MaThiSinh) = 12 and left(MaThiSinh,2) = 'TS' and right(MaThiSinh,10) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
Go
alter table TSHatVongBanKet add constraint CHK_TSHatVongBanKet_MaBH --Check mã BH
check(len(MaBH) = 8 and left(MaBH,2) = 'BH' and right(MaBH,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 28
if exists (select * from sys.objects where name='VongGala')
	drop table VongGala
Go
create table VongGala(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	ChuDe nvarchar(50) not null unique,
	MaNguoiHD varchar(12) not null,
	HatNhomFlag bit not null
)
Go
alter table VongGala add constraint PK_VongGala_STTVongThi_MaMuaThi
primary key(Sttvongthi,MaMuaThi)
Go --Khóa chính
alter table VongGala add constraint FK_VongGala_MaNguoiHD
foreign key(MaNguoiHD) references NgheSi(ID)
Go --Khóa ngoại
alter table VongGala add constraint FK_VongGala_SttVongThi_MaMuaThi 
foreign key(sttvongthi, mamuathi)  references VongThi(SttVongThi,MaMuaThi)
Go --Khóa ngoại
alter table VongGala add constraint CHK_VongGala_MaNguoiHD --Check mã NS
check(len(MaNguoiHD) = 8 and left(MaNguoiHD,2) = 'NS' and right(MaNguoiHD,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

--Bảng 29
if exists (select * from sys.objects where name='TSTGVongGala')
	drop table TSTGVongGala
Go
create table TSTGVongGala(
	STTvongthi int not null,
	MaMuaThi varchar(4) not null,
	MaThiSinh varchar(12) not null,
	MSBC char(4), --độ dài 4 và [0-9][0-9][0-9][0-9]
	TongSoTN int
)
alter table TSTGVongGala add constraint PK_TSTGVongGala_STTVongThi_MaMuaThi_MaThiSinh
primary key(Sttvongthi,MaMuaThi,MaThiSinh)
Go --Khóa chính
alter table TSTGVongGala add constraint FK_TSTGVongGala_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại  
alter table TSTGVongGala add constraint FK_TSTGVongGala_STTVongThi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongGala(STTVongThi,MaMuaThi)--Khóa ngoại
Go 
alter table TSTGVongGala add constraint CHK_TSTGVongGala_MSBC --Check mã MSBC
check(len(MSBC) = 4 and left(MSBC,2) = 'BC' and right(MSBC,2) like '[0-9][0-9]')
Go

--Bảng 30
if exists (select * from sys.objects where name='TSHatVongGaLa')
	drop table TSHatVongGaLa
create table TSHatVongGaLa(
	MaThiSinh varchar(12) not null,
	MaBH varchar(8) not null,
	STTvongthi int not null ,
	MaMuaThi varchar(4) not null,
)
Go
alter table TSHatVongGaLa add constraint PK_TSHatVongGaLat_MaThiSinh_MaBH
primary key(MaThiSinh,MaBH)
Go --Khóa chính
alter table TSHatVongGaLa add constraint FK_TSHatVongGaLa_MaThiSinh 
foreign key(MaThiSinh) references ThiSinh(ID)
Go --Khóa ngoại  
alter table TSHatVongGaLa add constraint FK_TSHatVongGaLa_STTVongthi_MaMuaThi 
foreign key(STTVongThi,MaMuaThi) references VongGala(STTVongThi,MaMuaThi)--Khóa ngoại
Go 
alter table TSHatVongGaLa add constraint CHK_TSHatVongGaLa_MaThiSinh --Check mã TS
check(len(MaThiSinh) = 12 and left(MaThiSinh,2) = 'TS' and right(MaThiSinh,10) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
Go
alter table TSHatVongGaLa add constraint CHK_TSHatVongGaLa_MaBH --Check mã BH
check(len(MaBH) = 8 and left(MaBH,2) = 'BH' and right(MaBH,6) like '[0-9][0-9][0-9][0-9][0-9][0-9]')
Go

set dateformat dmy
Go
--NHẬP DỮ LIỆU
insert into Nguoi values
('NS000001', '025762507', N'Đào Nguyệt Minh', 1, '25/7/1985', N'TP.HCM'),
('NS000002', '025761602', N'Lưu Thiên Hạo', 0, '14/5/1982', N'TP.HCM'),
('NS000003', '025760111', N'Tô Khiêm', 0, '13/3/1982', N'TP.HCM'),
('NS000004', '025760612', N'Lư Ái Như', 1, '14/2/1987', N'TP.HCM'),
('NS000005', '025760962', N'Lương Gia Bảo', 0, '23/9/1982', N'TP.HCM'),
('NS000006', '025760762', N'Nguyễn Bảo Hưng', 0, '23/9/1981', N'TP.HCM'),

('NS000007', '025760763', N'Justin Beiber', 0, '23/9/1989', N'Hoa Kì'),
('NS000008', '025760764', N'Burno Mars', 0, '21/9/1981', N'Hoa Kì'),
('NS000009', '025760765', N'Taylor Swift', 0, '23/9/1981', N'Hoa Kì'),
('NS000010', '025760766', N'Black Pink', 0, '23/9/1982', N'Hàn Quốc'),
('NS000011', '025760767', N'Justa Tee', 0, '22/9/1981', N'Hà Nội'),
('NS000012', '025760768', N'Phương Ly', 0, '25/9/1981', N'Hà Nội'),
('NS000013', '025760769', N'Thịnh Suy', 0, '27/9/1981', N'Hà Nội'),
('NS000014', '025760770', N'Đen Vâu', 0, '25/9/1981', N'TP.HCM'),
('NS000015', '025760771', N'Chris Brown', 0, '25/9/1985', N'Hoa Kì'),
('NS000016', '025760772', N'Hương Tràm', 0, '25/9/1989', N'Hà Nội'),
('NS000017', '025760773', N'Thanh Bùi', 0, '25/9/1987', N'Nước Úc'),
('NS000018', '025760774', N'Khánh Phương', 0, '25/9/1981', N'Trung Quốc')
Go --insert NS
insert into Nguoi values
('TS2012000001', '025761906', N'Trần Minh Triết', 0, '14/5/1995', N'TP.HCM'),
('TS2012000002', '025761907', N'Trần Minh Quốc', 0, '20/5/1995', N'TP.HCM'),
('TS2012000003', '025762657', N'Nguyễn Quốc Du', 0, '20/1/1995', N'TP.HCM'),
('TS2012000004', '025763590', N'Nguyễn Tiến Mạnh', 0, '1/7/1992', N'TP.HCM'),
('TS2012000005', '025763324', N'Nguyễn Thế Hữu', 0, '20/9/1988', N'TP.HCM'),
('TS2012000006', '025762210', N'Đinh Việt Thái', 0, '14/5/1984', N'TP.HCM'),
('TS2012000007', '025760412', N'Phạm Hồng Thái', 0, '20/3/1990', N'TP.HCM'),
('TS2012000008', '025766423', N'Ôn Minh Trí', 0, '11/4/1991', N'TP.HCM'),
('TS2012000009', '325761906', N'Dương Mẫn Đạt', 0, '10/3/1994', N'Bến Tre'),
('TS2012000010', '355761906', N'Lê Hoàng Anh Trí', 0, '6/1/1995', N'An Giang'),
('TS2012000011', '375766483', N'Trần Kim Hiếu', 1, '10/7/1993', N'Kiên Giang'),
('TS2012000012', '305764423', N'Tiền Khánh Chi', 1, '9/4/1992', N'Long An'),
('TS2012000013', '185766773', N'Trần Huyền My', 1, '13/3/1989', N'Hà Tĩnh'),
('TS2012000014', '345766672', N'Nguyễn Phương Thúy', 1, '7/6/1991', N'Đồng Tháp'),
('TS2012000015', '025766981', N'Mai Phương Thúy', 1, '10/2/1992', N'TP.HCM'),
('TS2012000016', '205761682', N'Lưu Gia Minh', 1, '19/6/1990', N'Quảng Nam'),
('TS2012000017', '195761280', N'Đoàn Thiên Kim', 1, '30/9/1989', N'Quảng Bình'),
('TS2012000018', '025760021', N'Hồ Thị Vân Anh', 1, '29/3/1991', N'TP.HCM'),
('TS2012000019', '025761234', N'Nguyễn Kim Ngân', 1, '14/4/1992', N'TP.HCM'),
('TS2012000020', '045761113', N'Trần Thị Tố Ny', 1, '12/6/1991', N'Điện Biên'),
('TS2012000021', '355766532', N'Cao Thanh Thảo My', 1, '9/5/1995', N'An Giang'),
('TS2012000022', '385766123', N'Cù Huyền Trang', 1, '11/1/1995', N'Cà Mau'),
('TS2012000023', '165764687', N'Phan Nguyễn Linh Chi', 1, '2/9/1992', N'Nam Định'),
('TS2012000024', '105766423', N'Nguyễn Thị Lệ Ngọc', 1, '18/3/1990', N'Quảng Ninh'),
('TS2012000025', '055766115', N'Nguyễn Thị Bảo Châu', 1, '30/4/1988', N'Sơn La'),
('TS2012000026', '275767619', N'Trần Thanh Huyền', 1, '1/5/1991', N'Vũng Tàu'),
('TS2012000027', '135766793', N'Nguyễn Thị Bảo Trâm', 1, '1/1/1995', N'Phú Thọ'),
('TS2012000028', '015766111', N'Trần Huỳnh Thanh Trúc', 1, '22/9/1991', N'Hà Nội'),
('TS2012000029', '025766232', N'Nguyễn Lê Thảo Vy', 1, '11/7/1993', N'TP.HCM'),
('TS2012000030', '025766999', N'Tiền Khánh Lộc', 0, '3/9/1995', N'TP.HCM')
Go --insert MT1
insert into Nguoi values
('TS2015000001', '025766464', N'Trần Uy Vũ', 0, '3/7/1999', N'TP.HCM'),
('TS2015000002', '015766919', N'Bùi Thiên Ân', 0, '7/7/1998', N'Hà Nội'),
('TS2015000003', '145767913', N'Nguyễn Hải Đăng', 0, '19/2/1995', N'Hải Dương'),
('TS2015000004', '025766714', N'Nguyễn Gia Bảo', 0, '15/3/1997', N'TP.HCM'),
('TS2015000005', '355764698', N'Bá Chấn Hưng', 0, '24/4/1999', N'An Giang'),
('TS2015000006', '385761678', N'Lê Hải Yến', 1, '19/10/1996', N'Bạc Liêu'),
('TS2015000007', '215766333', N'Trần Phúc Điền', 0, '3/7/1997', N'Bình Định'),
('TS2015000008', '025766670', N'Trần Thanh Liêm', 0, '5/2/1991', N'TP.HCM'),
('TS2015000009', '025766733', N'Đàm Minh Nhật', 0, '1/9/1999', N'TP.HCM'),
('TS2015000010', '325767823', N'Nguyễn Tuấn Kiệt', 0, '7/12/1992', N'Bến Tre'),
('TS2015000011', '265767521', N'Nguyễn Hữu Hà', 0, '17/11/1994', N'Bình Thuận'),
('TS2015000012', '085766951', N'Nguyễn Trọng Nghĩa', 0, '8/5/1992', N'Cao Bằng'),
('TS2015000013', '365766782', N'Lưu Thiện Ngôn', 0, '3/1/1991', N'Cần Thơ'),
('TS2015000014', '085766613', N'Lê Cát Tường', 1, '1/8/1991', N'Cao Bằng'),
('TS2015000015', '045766158', N'Thái Anh Thư', 1, '4/9/1995', N'Điện Biên'),
('TS2015000016', '275766492', N'Đàm Tịnh Yên', 1, '5/11/1998', N'Đồng Nai'),
('TS2015000017', '345766186', N'Ngô Gia Linh', 1, '7/6/1995', N'Đồng Tháp'),
('TS2015000018', '075766406', N'Tô Hạnh San', 1, '30/12/1993', N'Hà Giang'),
('TS2015000019', '165766007', N'Nguyễn Thương Nga', 1, '10/10/1991', N'Hà Nam'),
('TS2015000020', '215766006', N'Trần Trung Hiếu', 0, '20/11/1991', N'Quảng Ngãi'),
('TS2015000021', '145766189', N'Ngô Hà Mi', 1, '16/8/1991', N'Hải Dương'),
('TS2015000022', '165766125', N'Nguyễn Thanh Tâm', 1, '31/5/1991', N'Ninh Bình'),
('TS2015000023', '025766199', N'Nguyễn Song Thư', 1, '6/9/1995', N'TP.HCM'),
('TS2015000024', '225766936', N'Tô Dạ Thi', 1, '10/1/1994', N'Khánh Hòa'),
('TS2015000025', '375766070', N'Ngô Mộc Miên', 1, '12/12/1992', N'Kiên Giang'),
('TS2015000026', '195766490', N'Đàm Ngọc Liên', 1, '9/9/1991', N'Quảng Trị'),
('TS2015000027', '185766260', N'Trần Minh Khuê', 1, '19/2/1991', N'Nghệ An'),
('TS2015000028', '195766491', N'Đàm Vĩnh Xuân', 1, '8/9/1991', N'Quảng Trị'),
('TS2015000029', '195766477', N'Đàm Ngọc Tài', 1, '9/9/1994', N'Quảng Trị'),
('TS2015000030', '195766412', N'Lim Hiệp Tiến', 1, '9/9/1993', N'Quảng Trị')
Go --insert MT2
insert into ThiSinh values
('TS2012000001', 'TP.HCM', '0906566970', N'Xin chào mọi người'),
('TS2012000002', 'TP.HCM', '0906566971', N'Xin chào mọi người'),
('TS2012000003', 'TP.HCM', '0906566972', N'Xin chào mọi người'),
('TS2012000004', 'TP.HCM', '0906566973', N'Xin chào mọi người'),
('TS2012000005', 'TP.HCM', '0906566974', N'Xin chào mọi người'),
('TS2012000006', 'TP.HCM', '0906566975', N'Xin chào mọi người'),
('TS2012000007', 'TP.HCM', '0906566976', N'Xin chào mọi người'),
('TS2012000008', 'TP.HCM', '0906566977', N'Xin chào mọi người'),
('TS2012000009', N'Bến Tre','0906566978', N'Xin chào mọi người'),
('TS2012000010', N'An Giang', '0906566979', N'Xin chào mọi người'),
('TS2012000011', N'Kiên Giang', '0906566980', N'Xin chào mọi người'),
('TS2012000012', N'Long An', '0906566981', N'Xin chào mọi người'),
('TS2012000013', N'Hà Tĩnh', '0906566982', N'Xin chào mọi người'),
('TS2012000014', N'Đồng Tháp','0906566983', N'Xin chào mọi người'),
('TS2012000015', N'TP.HCM', '0906566984', N'Xin chào mọi người'),
('TS2012000016', N'Quảng Nam','0906566985', N'Xin chào mọi người'),
('TS2012000017', N'Quảng Bình', '0906566986', N'Xin chào mọi người'),
('TS2012000018', N'TP.HCM','0906566987', N'Xin chào mọi người'),
('TS2012000019', N'TP.HCM', '0906566988', N'Xin chào mọi người'),
('TS2012000020', N'Điện Biên','0906566989', N'Xin chào mọi người'),
('TS2012000021', N'An Giang', '0906566990', N'Xin chào mọi người'),
('TS2012000022', N'Cà Mau', '0906566991', N'Xin chào mọi người'),
('TS2012000023', N'Nam Định', '0906566992', N'Xin chào mọi người'),
('TS2012000024', N'Quảng Ninh', '0906566993', N'Xin chào mọi người'),
('TS2012000025', N'Sơn La', '0906566994', N'Xin chào mọi người'),
('TS2012000026', N'Vũng Tàu','0906566995', N'Xin chào mọi người'),
('TS2012000027', N'Phú Thọ', '0906566996', N'Xin chào mọi người'),
('TS2012000028', N'Hà Nội','0906566997', N'Xin chào mọi người'),
('TS2012000029', N'TP.HCM','0906566998', N'Xin chào mọi người'),
('TS2012000030', N'TP.HCM','0906566999', N'Xin chào mọi người'),
('TS2015000001', N'TP.HCM', '0906567000',N'Xin chào mọi người'),
('TS2015000002', N'Hà Nội','0906567001',N'Xin chào mọi người'),
('TS2015000003', N'Hải Dương', '0906567002', N'Xin chào mọi người'),
('TS2015000004', N'TP.HCM', '0906567003', N'Xin chào mọi người'),
('TS2015000005',  N'An Giang', '0906567004',N'Xin chào mọi người'),
('TS2015000006', N'Bạc Liêu', '0906567005',N'Xin chào mọi người'),
('TS2015000007', N'Bình Định', '0906567006',N'Xin chào mọi người'),
('TS2015000008', N'TP.HCM','0906567007', N'Xin chào mọi người'),
('TS2015000009', N'TP.HCM', '0906567008', N'Xin chào mọi người'),
('TS2015000010', N'Bến Tre', '0906567009', N'Xin chào mọi người'),
('TS2015000011', N'Bình Thuận', '0906567010', N'Xin chào mọi người'),
('TS2015000012', N'Cao Bằng', '0906567011', N'Xin chào mọi người'),
('TS2015000013', N'Cần Thơ', '0906567012', N'Xin chào mọi người'),
('TS2015000014', N'Cao Bằng', '0906567013', N'Xin chào mọi người'),
('TS2015000016', N'Đồng Nai', '0906567014', N'Xin chào mọi người'),
('TS2015000017', N'Đồng Tháp', '0906567015', N'Xin chào mọi người'),
('TS2015000018', N'Hà Giang', '0906567016', N'Xin chào mọi người'),
('TS2015000019', N'Hà Nam', '0906567017',N'Xin chào mọi người'),
('TS2015000020', N'Quảng Ngãi', '0906567018',N'Xin chào mọi người'),
('TS2015000021', N'Hải Dương', '0906567019',N'Xin chào mọi người'),
('TS2015000022', N'Ninh Bình', '0906567020',N'Xin chào mọi người'),
('TS2015000023', N'TP.HCM','0906567021',N'Xin chào mọi người'),
('TS2015000024', N'Khánh Hòa','0906567022',N'Xin chào mọi người'),
('TS2015000025', N'Kiên Giang', '0906567023',N'Xin chào mọi người'),
('TS2015000026',  N'Quảng Trị', '0906567024',N'Xin chào mọi người'),
('TS2015000027', N'Nghệ An', '0906567025',N'Xin chào mọi người'),
('TS2015000028', N'Quảng Trị', '0906567026',N'Xin chào mọi người'),
('TS2015000029', N'Quảng Trị', '0906567027',N'Xin chào mọi người'),
('TS2015000030', N'Quảng Trị',  '0906567028',N'Xin chào mọi người')
Go --insert ThiSinh
insert into Nghesi values
('NS000001', N'Nguyệt Lư', N'MC quốc dân', 1,0,0),
('NS000002', N'Hạo Nhiên', N'Nhạc sĩ sáng tác nhiều bài hit', 0,0,1),
('NS000003', N'Khiêm Nhường', N'Diva 2012', 0,1,0),
('NS000004', N'Ái Như', N'Ca sĩ có số lượng fan đông đảo', 0,1,0),
('NS000005', N'Bảo Bảo', N'Nhạc sĩ được khán giả yêu quý', 0,0,1),
('NS000006', N'Bảo Hưng Miền Tây', N'Ca sĩ bolero', 0,1,0),

('NS000007', N'Justin Beiber', N'Idol',0,1,1),
('NS000008', N'Burno Mars', N'Idol', 0,1,1),
('NS000009', N'Taylor Swift', N'Idol' , 0,1,1),
('NS000010', N'Black Pink', N'Idol', 0,1,1),
('NS000011', N'Justa Tee', N'Idol', 0,1,1),
('NS000012', N'Phương Ly', N'Idol',0,1,1),
('NS000013', N'Thịnh Suy', N'Idol',0,1,1),
('NS000014', N'Đen Vâu', N'Idol',0,1,1),
('NS000015', N'Chris Brown',N'Idol', 0,1,1),
('NS000016', N'Hương Tràm', N'Idol', 0,1,1),
('NS000017', N'Thanh Bùi', N'Idol', 0,1,1),
('NS000018', N'Khánh Phương',N'Idol', 0,1,0)
Go --insert Nghesi
insert into ChuongTrinhMC values 
('NS000001','We Choice Awards, Làn Sóng Xanh')
Go
insert into AlbumCaSi values 
('NS000003', N'Gửi anh xa nhớ'),
('NS000004', N'Bao giớ lấy chồng'),
('NS000006', N'Ai khóc nỗi đau này')
Go --insert AlbumCaSi
insert into BaiHat values
('BH000001', N'As long as you love me'),
('BH000002', N'Lazy song'),
('BH000003', N'Solo'),
('BH000004', N'Look what you made me do'),
('BH000005', N'King'),
('BH000006', N'Bâng khuâng'),
('BH000007', N'Mặt trời của em'),
('BH000008', N'Cùng anh'),
('BH000009', N'Em dạo này'),
('BH000010', N'Một đêm say'),
('BH000011', N'Rap god'),
('BH000012', N'Tau thích mi'),
('BH000013', N'Afraid'),
('BH000014', N'Anh đếch cần gì nhiều ngoài em'),
('BH000015', N'Look at me now'),
('BH000016', N'Lâu đài tình ái'),
('BH000017', N'Duyên phận'),
('BH000018', N'Sắc môi em hồng'),
('BH000019', N'Tình về nơi đâu'),
('BH000020', N'Chiếc khăn gió ấm')
Go --insert BaiHat
insert into TheLoai values
('TL001', N'Pop'),
('TL002', N'Indie'),
('TL003', N'Rap'),
('TL004', N'Love')
Go --insert TheLoai
insert into BaiHatThuocTheLoai values 
('BH000001', 'TL001'),
('BH000002', 'TL001'),
('BH000003', 'TL001'),
('BH000004', 'TL001'),
('BH000005', 'TL001'),
('BH000006', 'TL002'),
('BH000007', 'TL002'),
('BH000008', 'TL002'),
('BH000009', 'TL002'),
('BH000010', 'TL002'),
('BH000011', 'TL003'),
('BH000012', 'TL003'),
('BH000013', 'TL003'),
('BH000014', 'TL003'),
('BH000015', 'TL003'),
('BH000016', 'TL004'),
('BH000017', 'TL004'),
('BH000018', 'TL004'),
('BH000019', 'TL004'),
('BH000020', 'TL004')
Go
insert into NhacSiSangTac values
('NS000007','BH000001',3),
('NS000008','BH000002',3),
('NS000010','BH000003',2),
('NS000009','BH000004',3),
('NS000010','BH000005',2),
('NS000011','BH000006',3),
('NS000012','BH000007',3),
('NS000012','BH000008',2),
('NS000011','BH000009',3),
('NS000011','BH000010',2),
('NS000013','BH000011',2),
('NS000014','BH000012',2),
('NS000015','BH000013',2),
('NS000016','BH000014',2),
('NS000017','BH000015',2),
('NS000018','BH000016',2),
('NS000014','BH000017',2),
('NS000015','BH000018',2),
('NS000017','BH000019',2),
('NS000018','BH000020',2)
Go
insert into TinhThanh values
('TT01',N'Hà Nội'),
('TT02',N'Đà Nẵng'),
('TT03',N'TP.HCM'),
('TT04',N'Kiên Giang'),
('TT05',N'Thừa Thiên Huế'),
('TT06',N'Cần Thơ')
Go
insert into NhaSanXuat values
('NSX001',N'Bút Vàng Media'),
('NSX002',N'Điền Quân Media & Entertainment'),
('NSX003',N'HTV'),
('NSX004',N'VTV'),
('NSX005',N'Revolution Media & Entertainment')
Go
insert into KenhTruyenHinh values
('TH001',N'HTV7'),
('TH002',N'HTV5'),
('TH003',N'VTV3'),
('TH004',N'VTV6'),
('TH005',N'VTV1')
Go --insert kênh Truyền hình
insert into MuaThi(NgayBD,NgayKT,GiaiThuong,DiaDiemVongNhaHat,DiaDiemVongBanKet,DiaDiemVongGala,MaGiamDocAmNhac,MaGK1,MaGk2,MaGK3,MaMC) values
('01/07/2012','01/02/2013',N'Giải nhất 100 triệu đồng',N'Nhà hát thành phố',N'Nhà hát thành phố',N'Nhà hát thành phố','NS000002','NS000003','NS000004','NS000006','NS000001')
insert into MuaThi(NgayBD,NgayKT,GiaiThuong,DiaDiemVongNhaHat,DiaDiemVongBanKet,DiaDiemVongGala,MaGiamDocAmNhac,MaGK1,MaGk2,MaGK3,MaMC) values
('01/07/2013','01/02/2014',N'Giải nhất 200 triệu đồng',N'Nhà hát thành phố',N'Nhà hát thành phố',N'Nhà hát thành phố','NS000002','NS000003','NS000004','NS000006','NS000001')
insert into MuaThi(NgayBD,NgayKT,GiaiThuong,DiaDiemVongNhaHat,DiaDiemVongBanKet,DiaDiemVongGala,MaGiamDocAmNhac,MaGK1,MaGk2,MaGK3,MaMC) values
('01/07/2014','01/02/2015',N'Giải nhất 300 triệu đồng',N'Nhà hát thành phố',N'Nhà hát thành phố',N'Nhà hát thành phố','NS000005','NS000003','NS000004','NS000006','NS000001')
insert into MuaThi(NgayBD,NgayKT,GiaiThuong,DiaDiemVongNhaHat,DiaDiemVongBanKet,DiaDiemVongGala,MaGiamDocAmNhac,MaGK1,MaGk2,MaGK3,MaMC) values
('01/07/2015','01/02/2016',N'Giải nhất 400 triệu đồng',N'Nhà hát thành phố',N'Nhà hát thành phố',N'Nhà hát thành phố','NS000005','NS000003','NS000004','NS000006','NS000001')
insert into MuaThi(NgayBD,NgayKT,GiaiThuong,DiaDiemVongNhaHat,DiaDiemVongBanKet,DiaDiemVongGala,MaGiamDocAmNhac,MaGK1,MaGk2,MaGK3,MaMC) values
('01/07/2016','01/02/2017',N'Giải nhất 500 triệu đồng',N'Nhà hát thành phố',N'Nhà hát thành phố',N'Nhà hát thành phố','NS000005','NS000003','NS000004','NS000006','NS000001')
Go --insert mùa thi
insert into BanQuyenMuaThi values
('MT1','NSX001'),
('MT2','NSX002'),
('MT3','NSX003'),
('MT4','NSX004'),
('MT5','NSX005')
Go
insert into PhatSong values
('MT1','TH001',3),
('MT2','TH002',3),
('MT3','TH003',3),
('MT4','TH004',3),
('MT5','TH005',3)
Go
insert into VongThi values --MT1
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng thử giọng miền Bắc','01/07/2012 9:00','02/07/2012 17:00',1),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng thử giọng miền Trung','05/07/2012 9:00','06/07/2012 17:00',1),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng thử giọng miền Nam','08/07/2012 9:00','09/07/2012 17:00',1),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng thử giọng miền Tây','01/07/2012 9:00','11/07/2012 17:00',1),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Đơn ca với Piano','01/08/2012 9:00','03/08/2012 17:00',2),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Hát nhóm','05/08/2012 9:00','07/08/2012 17:00',2),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Đơn ca với ban nhạc','08/08/2012 9:00','09/08/2012 17:00',2),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Hát Bolero','10/08/2012 9:00','11/08/2012 17:00',2),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng Nam','05/09/2012 9:00','06/09/2012 17:00',3),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng Nữ','07/09/2012 9:00','08/09/2012 17:00',3),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng Vé Rớt','09/09/2012 9:00','10/09/2012 17:00',3),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Vòng Vé Rớt 2','11/09/2012 9:00','12/09/2012 17:00',3),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Tôi là ai','20/01/2013 9:00','22/01/2013 17:00',4),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Nhịp đập con tim','23/01/2013 9:00','25/01/2013 17:00',4),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Yêu nước','26/01/2013 9:00','28/01/2013 17:00',4),
(dbo.Func_SetVongThi('MT1'),'MT1',N'Chung kết','01/02/2013 17:00','01/02/2013 22:00',4)
Go
insert into VongThi values --MT4
(dbo.Func_SetVongThi('MT4'),'MT4',N'Vòng thử giọng miền Bắc','01/07/2015 9:00','02/07/2015 17:00',1),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Vòng thử giọng miền Trung','05/07/2015 9:00','06/07/2015 17:00',1),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Vòng thử giọng miền Nam','08/07/2015 9:00','09/07/2015 17:00',1),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Đơn ca với Piano','01/08/2015 9:00','03/08/2015 17:00',2),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Hát nhóm','05/08/2015 9:00','07/08/2015 17:00',2),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Vòng Nam','05/09/2015 9:00','06/09/2015 17:00',3),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Vòng Nữ','07/09/2015 9:00','08/09/2015 17:00',3),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Vòng Vé Rớt','09/09/2015 9:00','10/09/2015 17:00',3),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Vòng Nhịp đập sôi động','20/01/2016 9:00','25/01/2016 17:00',4),
(dbo.Func_SetVongThi('MT4'),'MT4',N'Chung kết','01/02/2016 17:00','01/02/2016 22:00',4)
Go
insert into TSTGVongThi values --Thu giong
(1,'MT1','TS2012000001',1),
(5,'MT1','TS2012000001',1),
(6,'MT1','TS2012000001',1),
(7,'MT1','TS2012000001',1),
(8,'MT1','TS2012000001',1),
(9,'MT1','TS2012000001',1),
(13,'MT1','TS2012000001',1),
(14,'MT1','TS2012000001',1),
(15,'MT1','TS2012000001',1),
(16,'MT1','TS2012000001',1),
(1,'MT1','TS2012000002',1),
(1,'MT1','TS2012000003',1),
(1,'MT1','TS2012000004',1),
(1,'MT1','TS2012000005',1),
(1,'MT1','TS2012000006',1),
(1,'MT1','TS2012000007',1),
(1,'MT1','TS2012000008',1),
(1,'MT1','TS2012000009',1),
(1,'MT1','TS2012000010',1),
(2,'MT1','TS2012000011',1),
(2,'MT1','TS2012000012',1),
(2,'MT1','TS2012000013',1),
(2,'MT1','TS2012000014',1),
(2,'MT1','TS2012000015',1),
(2,'MT1','TS2012000016',1),
(2,'MT1','TS2012000017',1),
(2,'MT1','TS2012000018',1),
(2,'MT1','TS2012000019',1),
(2,'MT1','TS2012000020',1),
(3,'MT1','TS2012000021',1),
(3,'MT1','TS2012000022',1),
(3,'MT1','TS2012000023',1),
(3,'MT1','TS2012000024',1),
(3,'MT1','TS2012000025',1),
(3,'MT1','TS2012000026',1),
(3,'MT1','TS2012000027',1),
(3,'MT1','TS2012000028',1),
(3,'MT1','TS2012000029',1),
(3,'MT1','TS2012000030',1)
Go
insert into VongThuGiong Values
(1,'MT1','TT01',N'Sân vận động Mỹ Đình'),
(2,'MT1','TT05',N'Indochine Palace Hotel'),
(3,'MT1','TT06',N'Khách sạn Chương Dương'),
(4,'MT1','TT04',N'Khách sạn Intercontinental')
Go
insert into TSTGVongThuGiong values
(1,'MT1','TS2012000001',1,1,1),
(1,'MT1','TS2012000002',1,1,0),
(1,'MT1','TS2012000003',1,1,0),
(1,'MT1','TS2012000004',1,1,1),
(1,'MT1','TS2012000005',1,1,0),
(1,'MT1','TS2012000006',1,1,0),
(1,'MT1','TS2012000007',1,1,0),
(1,'MT1','TS2012000008',1,1,1),
(1,'MT1','TS2012000009',1,1,0),
(1,'MT1','TS2012000010',1,1,0),
(2,'MT1','TS2012000011',1,1,0),
(2,'MT1','TS2012000012',1,0,1),
(2,'MT1','TS2012000013',1,1,0),
(2,'MT1','TS2012000014',1,1,0),
(2,'MT1','TS2012000015',1,1,0),
(2,'MT1','TS2012000016',1,1,0),
(2,'MT1','TS2012000017',1,0,1),
(2,'MT1','TS2012000018',1,1,0),
(2,'MT1','TS2012000019',1,1,0),
(2,'MT1','TS2012000020',1,1,0),
(3,'MT1','TS2012000021',1,1,0),
(3,'MT1','TS2012000022',1,0,1),
(3,'MT1','TS2012000023',1,1,0),
(3,'MT1','TS2012000024',0,1,1),
(3,'MT1','TS2012000025',1,1,0),
(3,'MT1','TS2012000026',1,1,0),
(3,'MT1','TS2012000027',1,1,0),
(3,'MT1','TS2012000028',1,1,0),
(3,'MT1','TS2012000029',0,1,1),
(3,'MT1','TS2012000030',1,1,0)
Go
insert into TSHatVongThuGiong values
(1,'MT1','TS2012000001','BH000019'),
(1,'MT1','TS2012000002','BH000001'),
(1,'MT1','TS2012000003','BH000002'),
(1,'MT1','TS2012000004','BH000003'),
(1,'MT1','TS2012000005','BH000004'),
(1,'MT1','TS2012000006','BH000005'),
(1,'MT1','TS2012000007','BH000006'),
(1,'MT1','TS2012000008','BH000007'),
(1,'MT1','TS2012000009','BH000008'),
(1,'MT1','TS2012000010','BH000009'),
(2,'MT1','TS2012000011','BH000010'),
(2,'MT1','TS2012000012','BH000011'),
(2,'MT1','TS2012000013','BH000012'),
(2,'MT1','TS2012000014','BH000013'),
(2,'MT1','TS2012000015','BH000014'),
(2,'MT1','TS2012000016','BH000015'),
(2,'MT1','TS2012000017','BH000016'),
(2,'MT1','TS2012000018','BH000017'),
(2,'MT1','TS2012000019','BH000018'),
(2,'MT1','TS2012000020','BH000019'),
(3,'MT1','TS2012000021','BH000020'),
(3,'MT1','TS2012000022','BH000003'),
(3,'MT1','TS2012000023','BH000005'),
(3,'MT1','TS2012000024','BH000001'),
(3,'MT1','TS2012000025','BH000006'),
(3,'MT1','TS2012000026','BH000007'),
(3,'MT1','TS2012000027','BH000008'),
(3,'MT1','TS2012000028','BH000009'),
(3,'MT1','TS2012000029','BH000010'),
(3,'MT1','TS2012000030','BH000011')
Go
insert into VongNhaHat values 
('8','MT1',0),
('7','MT1',0),
('5','MT1',0),
('6','MT1',1)
Go
insert into NhomCa values
('NC000001',N'Hello World','TS2012000001','TS2012000002','TS2012000003','TS2012000004'),
('NC000002',N'Black Pink','TS2012000005','TS2012000006','TS2012000007','TS2012000008'),
('NC000003',N'Shinee','TS2012000009','TS2012000010','TS2012000011','TS2012000012'),
('NC000004',N'Bức Tường','TS2012000013','TS2012000014','TS2012000015','TS2012000016')
Go
insert into NhomCaHatBH values 
('NC000001','BH000008',6,'MT1'),
('NC000002','BH000009',6,'MT1'),
('NC000003','BH000010',6,'MT1'),
('NC000004','BH000011',6,'MT1')
Go
insert into VongBanKet values 
(9,'MT1',0),
(10,'MT1',1),
(11,'MT1',-1),
(12,'MT1',-1)
Go
insert into TSTGVongBanKet values
(9,'MT1','TS2012000001','BC01',5000),
(9,'MT1','TS2012000002','BC02',500),
(9,'MT1','TS2012000003','BC03',600),
(9,'MT1','TS2012000004','BC04',700)
Go
insert into TSHatVongBanKet values
('TS2012000001','BH000008',9,'MT1'),
('TS2012000002','BH000009',10,'MT1'),
('TS2012000003','BH000010',11,'MT1'),
('TS2012000004','BH000011',12,'MT1')
Go
insert into VongGala values 
(13,'MT1',N'Tôi là ai','NS000016',1),
(14,'MT1',N'Nhịp đập con tim','NS000017',1),
(15,'MT1',N'Yêu nước','NS000005',0),
(16,'MT1',N'Chung kết','NS000018',0)
Go
insert into TSTGVongGala values
(13,'MT1','TS2012000001','BC01',5000),
(14,'MT1','TS2012000002','BC02',500),
(15,'MT1','TS2012000003','BC03',600),
(16,'MT1','TS2012000004','BC04',700)
Go
insert into TSHatVongGaLa values
('TS2012000001','BH000001',13,'MT1'),
('TS2012000002','BH000002',14,'MT1'),
('TS2012000003','BH000003',15,'MT1'),
('TS2012000004','BH000004',16,'MT1')
Go
--INDEX
CREATE INDEX Index_TT_VongThi on VongThi(STTVongThi,MaMuaThi)
CREATE INDEX Index_TT_ThiSinh on Nguoi(CMND)
CREATE INDEX Index_TT_MuaThi on MuaThi(NgayBD)
Go

--Store Procedure / Function
Create Procedure uspMinSTTVongThi(@MaMuaGiai as varchar(4)
									,@LoaiVongThi as int
) -- Lấy STT nhỏ nhất
As 
Begin
		Select top(1) STTVongThi as N'Số thứ tự bé nhất trong loại vòng thi'
		from dbo.VongThi 
		where MaMuaThi = @MaMuaGiai and LoaiVongThi = @LoaiVongThi 
		order by SttVongThi ASC
End
Go 
EXECUTE uspMinSTTVongThi 'MT1', 4
Go

Create Procedure uspMaxSTTVongThi(@MaMuaGiai as varchar(4)
									,@LoaiVongThi as int
) -- Lấy STT lớn nhất
As 
Begin
		Select top(1) STTVongThi as N'Số thứ tự lớn nhất trong loại vòng thi'
		from dbo.VongThi 
		where MaMuaThi = @MaMuaGiai and LoaiVongThi = @LoaiVongThi 
		order by SttVongThi DESC
End
Go 
EXECUTE uspMaxSTTVongThi 'MT1', 4
Go

--Update
UPDATE TSTGVongGala Set TongSoTN = 10000 where MaThiSinh = 'TS2012000001' and MaMuaThi = 'MT1'
Go

--DELETE
DELETE FROM ThiSinh
WHERE ID = 'TS2012000001'
--Xóa dữ liệu thành công trong trường hợp dữ liệu cần xóa không tham chiếu tới bất kỳ dữ liệu nào của bảng khác
--Khi xóa dữ liệu thành công thì chỉ bảng ThiSinh sẽ bị ảnh hưởng bởi thao tác xóa này
--vì điều kiện xóa dữ liệu thành công là dữ liệu cần xóa không tham chiếu tới bất kỳ dữ liệu nào của bảng khác nên sẽ không ảnh hưởng tới các bảng khác
Go

--SELECT
Select a.CMND, a.HoTen as N'Họ và tên',b.DiaChi as N'Địa chỉ', b.DienThoai as N'Điện thoại'
From Nguoi a, ThiSinh b, MuaThi c, TSTGVongThi d
Where a.ID = b.ID and c.ID = d.MaMuaThi and b.ID = d.MaThiSinh
and d.KetQua = 1 and d.SttVongThi = 16 and d.MaMuaThi = 'MT1' --Tìm Quán Quân
Go 

--Phân Quyền
Use VietNamIdol
Go
sp_addlogin 'Nhanvien' , '123456' , 'VietNamIdol'
Go
sp_addlogin 'Quanly' , '123456' , 'VietNamIdol'
Go
sp_adduser 'Quanly' , 'Quanly'
Go
sp_adduser 'Nhanvien' , 'Nhanvien' 
Go
----của quản lý
USE VietNamIdol 
GO 
GRANT ALL ON AlbumCaSi TO Quanly 
GRANT ALL ON BaiHat TO Quanly 
GRANT ALL ON BaiHatThuocTheLoai TO Quanly 
GRANT ALL ON BanQuyenMuaThi TO Quanly 
GRANT ALL ON ChuongTrinhMC TO Quanly 
GRANT ALL ON KenhTruyenHinh TO Quanly 
GRANT ALL ON MuaThi TO Quanly 
GRANT ALL ON NgheSi TO Quanly 
GRANT ALL ON Nguoi TO Quanly 
GRANT ALL ON NhacSiSangTac TO Quanly 
GRANT ALL ON NhaSanXuat TO Quanly 
GRANT ALL ON NhomCa TO Quanly 
GRANT ALL ON NhomCaHatBH TO Quanly 
GRANT ALL ON PhatSong TO Quanly 
GRANT ALL ON TheLoai TO Quanly 
GRANT ALL ON ThiSinh TO Quanly 
GRANT ALL ON TinhThanh TO Quanly 
GRANT ALL ON TSHatVongBanKet TO Quanly 
GRANT ALL ON TSHatVongGala TO Quanly 
GRANT ALL ON TSHatVongNhaHat TO Quanly 
GRANT ALL ON TSHatVongThuGiong TO Quanly 
GRANT ALL ON TSTGVongBanKet TO Quanly 
GRANT ALL ON TSTGVongGala TO Quanly 
GRANT ALL ON TSTGVongThi TO Quanly 
GRANT ALL ON TSTGVongThuGiong TO Quanly 
GRANT ALL ON VongBanKet TO Quanly 
GRANT ALL ON VongGala TO Quanly 
GRANT ALL ON VongNhaHat TO Quanly 
GRANT ALL ON VongThi TO Quanly 
GRANT ALL ON VongThuGiong TO Quanly 
GRANT ALL TO QuanLy 
--Của nhân viên
GRANT SELECT, INSERT, UPDATE, DELETE ON Nguoi TO Nhanvien 
GRANT SELECT, INSERT, UPDATE, DELETE ON ThiSinh TO Nhanvien 
GRANT SELECT, INSERT, UPDATE, DELETE ON NgheSi TO Nhanvien 
GRANT SELECT, INSERT, UPDATE, DELETE ON AlbumCaSi TO Nhanvien 
GRANT SELECT, INSERT, UPDATE, DELETE ON BaiHat TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON BaiHatThuocTheLoai TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON BanQuyenMuaThi TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON ChuongTrinhMC TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON KenhTruyenHinh TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON MuaThi TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON NhacSiSangTac TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON NhaSanXuat TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON PhatSong TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON TheLoai TO Nhanvien   
GRANT SELECT, INSERT, UPDATE, DELETE ON TinhThanh TO Nhanvien  
GRANT SELECT, INSERT, UPDATE, DELETE ON VongThi TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON VongThuGiong TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON VongNhaHat TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON VongGala TO Nhanvien
GRANT SELECT, INSERT, UPDATE, DELETE ON TSTGVongThi TO Nhanvien           
GRANT SELECT, INSERT ON TSTGVongThuGiong TO Nhanvien 
GRANT SELECT, INSERT ON TSHatVongThuGiong TO Nhanvien
GRANT SELECT, INSERT ON TSHatVongNhaHat TO Nhanvien
GRANT SELECT, INSERT ON NhomCa TO Nhanvien   
GRANT SELECT, INSERT ON NhomCaHatBH TO Nhanvien
GRANT SELECT, INSERT ON VongBanKet TO Nhanvien  
GRANT SELECT, INSERT ON TSTGVongBanKet TO Nhanvien 
GRANT SELECT, INSERT ON TSHatVongBanKet TO Nhanvien 
GRANT SELECT, INSERT ON TSTGVongGala TO Nhanvien
GRANT SELECT, INSERT ON TSHatVongGala TO Nhanvien  