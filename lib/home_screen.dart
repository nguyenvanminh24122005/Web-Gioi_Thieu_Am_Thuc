import 'package:flutter/material.dart';
import 'food_detail_screen.dart';
import 'street_foods_screen.dart';
import 'north_foods_screen.dart';
import 'region_foods_screen.dart';
import 'all_foods_screen.dart';
import 'favorites_screen_pro.dart';
import 'profile_screen.dart';
import 'screens/recipes/recipe_list_screen.dart';
import 'screens/notification_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final ScrollController _foodScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  void _scrollLeft() {
    _foodScrollController.animateTo(
      (_foodScrollController.offset - 200).clamp(
        0,
        _foodScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _foodScrollController.animateTo(
      (_foodScrollController.offset + 200).clamp(
        0,
        _foodScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  @override
  void dispose() {
    _foodScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  // Danh sách món (để bấm vào mở chi tiết)
  final List<FoodItem> foods = const [
    // ====== THÊM 10 MÓN MIỀN BẮC ======
      // ====== THÊM 10 MÓN MIỀN TRUNG ======
FoodItem(
  id: 'caolau',
  name: 'Cao Lầu',
  priceRange: '30k - 60k',
  rating: '4.8',
  location: '(Hội An, VN)',
  story: 'Cao lầu sợi dai, thịt xá xíu, rau sống, nước trộn đậm đà – đặc trưng phố Hội.',
  ingredients: ['Mì cao lầu', 'Thịt', 'Rau sống', 'Da heo chiên', 'Nước trộn'],
  imageAsset: 'assets/images/cao_lau.jpg',
),
FoodItem(
  id: 'comhen',
  name: 'Cơm Hến',
  priceRange: '20k - 45k',
  rating: '4.7',
  location: '(Huế, VN)',
  story: 'Cơm hến cay nhẹ, thơm mắm ruốc, ăn giòn vui miệng với tóp mỡ và rau.',
  ingredients: ['Cơm', 'Hến', 'Mắm ruốc', 'Tóp mỡ', 'Rau thơm', 'Ớt'],
  imageAsset: 'assets/images/com_hen.jpg',
),
FoodItem(
  id: 'banhbeo',
  name: 'Bánh Bèo',
  priceRange: '15k - 40k',
  rating: '4.6',
  location: '(Huế, VN)',
  story: 'Bánh bèo chén mềm, rắc tôm chấy, hành phi, chan nước mắm ngọt mặn vừa.',
  ingredients: ['Bột gạo', 'Tôm chấy', 'Hành phi', 'Nước mắm', 'Da heo chiên'],
  imageAsset: 'assets/images/banh_beo.jpg',
),
FoodItem(
  id: 'banhnam',
  name: 'Bánh Nậm',
  priceRange: '15k - 35k',
  rating: '4.6',
  location: '(Huế, VN)',
  story: 'Bánh nậm gói lá mềm mịn, nhân tôm thịt thơm, ăn nhẹ mà cuốn.',
  ingredients: ['Bột gạo', 'Tôm', 'Thịt', 'Lá dong', 'Hành'],
  imageAsset: 'assets/images/banh_nam.jpg',
),
FoodItem(
  id: 'banhloc',
  name: 'Bánh Bột Lọc',
  priceRange: '15k - 40k',
  rating: '4.7',
  location: '(Huế, VN)',
  story: 'Bánh bột lọc trong dai, nhân tôm thịt đậm vị, chấm nước mắm ớt đúng điệu.',
  ingredients: ['Bột năng', 'Tôm', 'Thịt', 'Hành phi', 'Nước mắm', 'Ớt'],
  imageAsset: 'assets/images/banh_bot_loc.jpg',
),
FoodItem(
  id: 'nemlui',
  name: 'Nem Lụi',
  priceRange: '25k - 55k',
  rating: '4.7',
  location: '(Huế, VN)',
  story: 'Nem lụi nướng thơm, cuốn bánh tráng rau sống, chấm tương đặc sánh.',
  ingredients: ['Thịt', 'Sả', 'Bánh tráng', 'Rau sống', 'Tương'],
  imageAsset: 'assets/images/nem_lui.jpg',
),
FoodItem(
  id: 'buncha_ca_qn',
  name: 'Bún Chả Cá',
  priceRange: '30k - 60k',
  rating: '4.7',
  location: '(Quy Nhơn, VN)',
  story: 'Nước dùng trong ngọt, chả cá thơm dai, ăn kèm rau và ớt xanh.',
  ingredients: ['Bún', 'Chả cá', 'Cà chua', 'Hành', 'Rau', 'Ớt'],
  imageAsset: 'assets/images/bun_cha_ca.jpg',
),
FoodItem(
  id: 'banhcanhcha_ca',
  name: 'Bánh Canh Chả Cá',
  priceRange: '30k - 65k',
  rating: '4.6',
  location: '(Nha Trang, VN)',
  story: 'Sợi bánh canh mềm, chả cá chiên/hấp thơm, nước lèo ngọt thanh.',
  ingredients: ['Bánh canh', 'Chả cá', 'Hành lá', 'Tiêu', 'Nước dùng'],
  imageAsset: 'assets/images/banh_canh_cha_ca.jpg',
),
FoodItem(
  id: 'banhtrangcuonthitheo',
  name: 'Bánh Tráng Cuốn Thịt Heo',
  priceRange: '35k - 80k',
  rating: '4.8',
  location: '(Đà Nẵng, VN)',
  story: 'Thịt heo luộc, rau sống, bánh tráng cuốn và chấm mắm nêm “đỉnh”.',
  ingredients: ['Thịt heo', 'Bánh tráng', 'Rau sống', 'Dưa leo', 'Mắm nêm'],
  imageAsset: 'assets/images/banh_trang_cuon_thit_heo.jpg',
),
FoodItem(
  id: 'chebap',
  name: 'Chè Bắp',
  priceRange: '10k - 25k',
  rating: '4.5',
  location: '(Huế, VN)',
  story: 'Chè bắp ngọt dịu, thơm bắp non, thêm nước cốt dừa béo nhẹ mát lành.',
  ingredients: ['Bắp', 'Đường', 'Bột năng', 'Nước cốt dừa', 'Muối'],
  imageAsset: 'assets/images/che_bap.jpg',
),
// ====== THÊM 10 MÓN MIỀN NAM ======
FoodItem(
  id: 'banhtrangtron',
  name: 'Bánh Tráng Trộn',
  priceRange: '15k - 35k',
  rating: '4.6',
  location: '(TP.HCM, VN)',
  story: 'Bánh tráng trộn chua cay mặn ngọt, topping nhiều – đúng kiểu ăn vặt Sài Gòn.',
  ingredients: ['Bánh tráng', 'Trứng cút', 'Khô bò', 'Rau răm', 'Sa tế', 'Nước sốt'],
  imageAsset: 'assets/images/banh_trang_tron.jpg',
),
FoodItem(
  id: 'bunmam',
  name: 'Bún Mắm',
  priceRange: '35k - 80k',
  rating: '4.7',
  location: '(Miền Tây, VN)',
  story: 'Bún mắm đậm đà mắm cá, topping phong phú, rau sống nhiều loại ăn cực đã.',
  ingredients: ['Bún', 'Mắm cá', 'Tôm', 'Mực', 'Thịt', 'Rau sống'],
  imageAsset: 'assets/images/bun_mam.jpg',
),
FoodItem(
  id: 'laumam',
  name: 'Lẩu Mắm',
  priceRange: '120k - 250k',
  rating: '4.8',
  location: '(Miền Tây, VN)',
  story: 'Lẩu mắm thơm nồng, ăn kèm rau đồng và hải sản/thịt – đúng chất miền sông nước.',
  ingredients: ['Mắm', 'Cá', 'Tôm', 'Thịt', 'Rau đồng', 'Bún'],
  imageAsset: 'assets/images/lau_mam.jpg',
),
FoodItem(
  id: 'pha_lau',
  name: 'Phá Lấu',
  priceRange: '20k - 50k',
  rating: '4.6',
  location: '(TP.HCM, VN)',
  story: 'Phá lấu béo thơm, nước dùng sánh nhẹ, ăn với bánh mì hoặc mì gói đều ngon.',
  ingredients: ['Nội tạng', 'Nước cốt dừa', 'Ngũ vị', 'Bánh mì', 'Ớt'],
  imageAsset: 'assets/images/pha_lau.jpg',
),
FoodItem(
  id: 'bokho',
  name: 'Bò Kho',
  priceRange: '30k - 70k',
  rating: '4.7',
  location: '(Miền Nam, VN)',
  story: 'Bò kho thơm ngũ vị, thịt mềm, nước sánh – ăn kèm bánh mì hoặc hủ tiếu đều hợp.',
  ingredients: ['Bò', 'Cà rốt', 'Sả', 'Quế', 'Hành', 'Bánh mì'],
  imageAsset: 'assets/images/bo_kho.jpg',
),
FoodItem(
  id: 'cakhotto',
  name: 'Cá Kho Tộ',
  priceRange: '40k - 120k',
  rating: '4.7',
  location: '(Miền Nam, VN)',
  story: 'Cá kho tộ đậm vị nước màu, tiêu cay nhẹ, ăn cơm nóng rất đưa cơm.',
  ingredients: ['Cá', 'Nước mắm', 'Đường', 'Tiêu', 'Hành', 'Ớt'],
  imageAsset: 'assets/images/ca_kho_to.jpg',
),
FoodItem(
  id: 'banhcanhghe',
  name: 'Bánh Canh Ghẹ',
  priceRange: '45k - 120k',
  rating: '4.8',
  location: '(Vũng Tàu, VN)',
  story: 'Nước dùng ngọt từ ghẹ, sợi bánh canh mềm, ăn nóng cực “đã”.',
  ingredients: ['Bánh canh', 'Ghẹ', 'Hành lá', 'Tiêu', 'Nước dùng'],
  imageAsset: 'assets/images/banh_canh-ghe.jpg',
),
FoodItem(
  id: 'banhpiatranh',
  name: 'Bánh Pía',
  priceRange: '20k - 60k',
  rating: '4.5',
  location: '(Sóc Trăng, VN)',
  story: 'Bánh pía thơm sầu riêng, nhân đậu xanh trứng muối béo bùi – đặc sản miền Tây.',
  ingredients: ['Bột', 'Đậu xanh', 'Sầu riêng', 'Trứng muối', 'Đường'],
  imageAsset: 'assets/images/banh_pia.jpg',
),
FoodItem(
  id: 'banhtet',
  name: 'Bánh Tét',
  priceRange: '40k - 120k',
  rating: '4.6',
  location: '(Miền Nam, VN)',
  story: 'Bánh tét dẻo thơm, nhân đậu xanh thịt mỡ, thường có dịp Tết và lễ.',
  ingredients: ['Nếp', 'Đậu xanh', 'Thịt mỡ', 'Lá chuối', 'Tiêu'],
  imageAsset: 'assets/images/banh_tet.jpg',
),
FoodItem(
  id: 'cangochien',
  name: 'Càng Cua Chiên',
  priceRange: '15k - 35k',
  rating: '4.4',
  location: '(TP.HCM, VN)',
  story: 'Món ăn vặt giòn thơm, chấm tương ớt, thường thấy ở xe đẩy trước cổng trường.',
  ingredients: ['Bột', 'Càng cua', 'Gia vị', 'Tương ớt', 'Dầu ăn'],
  imageAsset: 'assets/images/cang_cua_chien.jpg',
),
      FoodItem(
        id: 'bunthang',
        name: 'Bún Thang',
        priceRange: '35k - 70k',
        rating: '4.8',
        location: '(Hà Nội, VN)',
        story: 'Bún thang thanh nhẹ, nước dùng trong thơm, topping trứng, giò, gà xé rất tinh tế.',
        ingredients: ['Bún', 'Gà', 'Trứng', 'Giò lụa', 'Nấm hương', 'Hành lá'],
        imageAsset: 'assets/images/bun_thang.jpg',
      ),
      FoodItem(
        id: 'banhcuon',
        name: 'Bánh Cuốn',
        priceRange: '20k - 45k',
        rating: '4.7',
        location: '(Hà Nội, VN)',
        story: 'Bánh cuốn mỏng mềm, nhân thịt mộc nhĩ, chấm nước mắm pha thơm hành phi.',
        ingredients: ['Bột gạo', 'Thịt băm', 'Mộc nhĩ', 'Hành phi', 'Nước mắm'],
        imageAsset: 'assets/images/banh_cuon.jpg',
      ),
      FoodItem(
        id: 'nemran',
        name: 'Nem Rán',
        priceRange: '25k - 60k',
        rating: '4.8',
        location: '(Miền Bắc, VN)',
        story: 'Nem rán giòn rụm, nhân đầy đặn, ăn kèm bún và rau sống rất “bắt miệng”.',
        ingredients: ['Bánh đa nem', 'Thịt', 'Miến', 'Mộc nhĩ', 'Trứng', 'Rau sống'],
        imageAsset: 'assets/images/nem_ran.jpg',
      ),
      FoodItem(
        id: 'xoixeo',
        name: 'Xôi Xéo',
        priceRange: '10k - 30k',
        rating: '4.6',
        location: '(Hà Nội, VN)',
        story: 'Xôi dẻo thơm nếp, đậu xanh nghiền mịn, hành phi béo bùi – chuẩn bữa sáng Hà Nội.',
        ingredients: ['Nếp', 'Đậu xanh', 'Hành phi', 'Mỡ gà', 'Muối vừng'],
        imageAsset: 'assets/images/xoi_xeo.jpg',
      ),
      FoodItem(
        id: 'chamuchalong',
        name: 'Chả Mực Hạ Long',
        priceRange: '50k - 120k',
        rating: '4.9',
        location: '(Quảng Ninh, VN)',
        story: 'Chả mực giã tay thơm, dai giòn tự nhiên, ăn nóng với xôi hoặc bánh cuốn cực hợp.',
        ingredients: ['Mực', 'Tiêu', 'Hành', 'Thì là', 'Dầu ăn'],
        imageAsset: 'assets/images/cha_muc_ha_long.jpg',
      ),
      FoodItem(
        id: 'buncahp',
        name: 'Bún Cá Hải Phòng',
        priceRange: '30k - 60k',
        rating: '4.7',
        location: '(Hải Phòng, VN)',
        story: 'Bún cá thơm dấm bỗng, cá rán vàng, nước dùng chua thanh dễ ăn.',
        ingredients: ['Bún', 'Cá', 'Dọc mùng', 'Cà chua', 'Dấm bỗng', 'Rau'],
        imageAsset: 'assets/images/bun_ca_hai_phong.jpg',
      ),
      FoodItem(
        id: 'chaomoc',
        name: 'Cháo Sườn',
        priceRange: '15k - 35k',
        rating: '4.6',
        location: '(Hà Nội, VN)',
        story: 'Cháo sườn sánh mịn, nóng hổi, ăn kèm quẩy giòn và ruốc thơm.',
        ingredients: ['Gạo', 'Sườn', 'Hành', 'Tiêu', 'Quẩy', 'Ruốc'],
        imageAsset: 'assets/images/chao_suon.jpg',
      ),
      FoodItem(
        id: 'banhducnong',
        name: 'Bánh Đúc Nóng',
        priceRange: '15k - 35k',
        rating: '4.5',
        location: '(Hà Nội, VN)',
        story: 'Bánh đúc mềm mịn, chan nước mắm thịt băm, mộc nhĩ – ăn ấm bụng ngày lạnh.',
        ingredients: ['Bột gạo', 'Thịt băm', 'Mộc nhĩ', 'Hành phi', 'Nước mắm'],
        imageAsset: 'assets/images/banh_duc_nong.jpg',
      ),
      FoodItem(
        id: 'bunrieucua',
        name: 'Bún Riêu Cua',
        priceRange: '25k - 55k',
        rating: '4.8',
        location: '(Miền Bắc, VN)',
        story: 'Bún riêu cua thơm vị cua đồng, cà chua chua nhẹ, ăn kèm rau sống rất đã.',
        ingredients: ['Bún', 'Cua đồng', 'Cà chua', 'Đậu phụ', 'Mắm tôm', 'Rau sống'],
        imageAsset: 'assets/images/bun_rieu_cua.jpg',
      ),
      FoodItem(
        id: 'thitcho',
        name: 'Thịt Chó (Đặc sản)',
        priceRange: '80k - 200k',
        rating: '4.3',
        location: '(Miền Bắc, VN)',
        story: 'Món đặc sản theo vùng miền (không phổ biến với mọi người), thường ăn kèm mắm tôm và lá mơ.',
        ingredients: ['Thịt', 'Riềng', 'Sả', 'Mắm tôm', 'Lá mơ', 'Ớt'],
        imageAsset: 'assets/images/thit_cho.jpg',
      ),
    FoodItem(
      id: 'banhmi',
      name: 'Bánh Mì',
      priceRange: '15k - 45k',
      rating: '4.9',
      location: '(Hà Nội, VN)',
      story:
          'Bánh mì Việt Nam là biểu tượng ẩm thực đường phố với lớp vỏ giòn rụm, ruột mềm nhẹ và hương thơm đặc trưng. '
          'Điểm hấp dẫn nằm ở phần nhân đa dạng: thịt nguội, pate béo thơm, chả lụa, kèm dưa góp giòn và rau thơm. '
          'Khi cắn một miếng, bạn sẽ cảm nhận rõ sự cân bằng giữa béo – mặn – chua nhẹ – thơm, rất “đã” nhưng không ngấy. '
          'Đây là món ăn tiện lợi, phù hợp bữa sáng hoặc bữa xế, dễ tìm và luôn tạo cảm giác thân quen.',
      ingredients: ['Bánh mì', 'Pate', 'Dưa góp', 'Rau thơm'],
      imageAsset: 'assets/images/banh_mi.jpg',
    ),
    FoodItem(
      id: 'bunbohue',
      name: 'Bún Bò Huế',
      priceRange: '30k - 60k',
      rating: '4.8',
      location: '(Huế, VN)',
      story:
          'Bún bò Huế nổi tiếng với nước dùng đậm đà, thơm mùi sả, điểm chút cay nồng của ớt sa tế. '
          'Sợi bún to, mềm nhưng vẫn giữ độ dai, ăn kèm thịt bò, giò heo và chả cua (tùy quán). '
          'Món này “ghi điểm” nhờ sự phức hợp hương vị: ngọt từ xương, thơm từ sả, cay vừa đủ và hậu vị rất rõ. '
          'Thưởng thức đúng điệu là thêm rau sống, bắp chuối, chanh và một ít mắm ruốc để tròn vị miền Trung.',
      ingredients: ['Bún', 'Bò', 'Sả', 'Sa tế', 'Rau sống'],
      imageAsset: 'assets/images/bun_bo_hue.jpg',
    ),
    FoodItem(
      id: 'phobo',
      name: 'Phở Bò',
      priceRange: '35k - 70k',
      rating: '4.9',
      location: '(Hà Nội, VN)',
      story:
          'Phở bò chuẩn vị Bắc có nước dùng trong, ngọt thanh từ xương hầm lâu, thoảng mùi quế – hồi – thảo quả. '
          'Thịt bò có thể là tái, chín, nạm hoặc gầu; bánh phở mềm, bản vừa, không nát. '
          'Điểm đặc trưng của phở Hà Nội là sự tinh tế: không quá nhiều gia vị, tập trung vào độ “ngọt thật” và mùi thơm nhẹ. '
          'Khi ăn, thêm hành lá, hành tây, chút chanh/ớt tùy khẩu vị để giữ cân bằng và làm dậy hương.',
      ingredients: ['Bánh phở', 'Bò', 'Quế hồi', 'Hành lá', 'Gừng nướng'],
      imageAsset: 'assets/images/pho_bo.jpg',
    ),
    FoodItem(
      id: 'comtam',
      name: 'Cơm Tấm',
      priceRange: '25k - 50k',
      rating: '4.7',
      location: '(TP.HCM, VN)',
      story:
          'Cơm tấm là “đặc sản” Sài Gòn với hạt cơm tơi từ gạo tấm, ăn cùng sườn nướng thơm lừng. '
          'Một dĩa cơm tấm chuẩn thường có bì, chả trứng, mỡ hành và đồ chua. '
          'Linh hồn của món nằm ở nước mắm pha: mặn ngọt hài hòa, hơi sệt nhẹ và thơm tỏi ớt. '
          'Món này no lâu, hợp bữa trưa hoặc tối, đặc biệt ngon khi sườn vừa nướng xong còn nóng.',
      ingredients: ['Cơm tấm', 'Sườn nướng', 'Mỡ hành', 'Đồ chua', 'Nước mắm'],
      imageAsset: 'assets/images/com_tam.jpg',
    ),
    FoodItem(
      id: 'banhxeo',
      name: 'Bánh Xèo',
      priceRange: '20k - 45k',
      rating: '4.8',
      location: '(Miền Trung, VN)',
      story:
          'Bánh xèo gây ấn tượng với lớp vỏ vàng giòn, thơm mùi bột gạo và nghệ, bên trong là tôm, thịt và giá đỗ. '
          'Cách ăn đúng là cuốn bánh với rau sống, chấm nước mắm chua ngọt hoặc mắm nêm tùy vùng. '
          'Sự hấp dẫn nằm ở tương phản: vỏ giòn rụm – nhân mềm ngọt – rau tươi mát. '
          'Ngon nhất khi ăn ngay lúc bánh vừa đổ xong, giữ được độ giòn và hương thơm.',
      ingredients: ['Bột gạo', 'Tôm', 'Thịt', 'Giá đỗ', 'Rau sống'],
      imageAsset: 'assets/images/banh_xeo.jpg',
    ),
    FoodItem(
      id: 'buncha',
      name: 'Bún Chả',
      priceRange: '30k - 55k',
      rating: '4.9',
      location: '(Hà Nội, VN)',
      story:
          'Bún chả là món “quốc dân” Hà Nội: chả nướng thơm (chả miếng và chả viên), ăn với bún và rau sống. '
          'Nước chấm pha chuẩn có vị mặn ngọt vừa, thêm đu đủ/xu hào ngâm giòn để tăng độ sảng khoái. '
          'Chả nướng quyết định chất lượng: thơm khói nhẹ, không khô, có chút xém cạnh hấp dẫn. '
          'Món này ngon nhất khi ăn nóng, chấm đẫm nước mắm để bún thấm vị.',
      ingredients: ['Bún', 'Chả nướng', 'Rau sống', 'Đồ ngâm', 'Nước mắm'],
      imageAsset: 'assets/images/bun_cha.jpg',
    ),
    FoodItem(
      id: 'goicuon',
      name: 'Gỏi Cuốn',
      priceRange: '10k - 25k',
      rating: '4.6',
      location: '(Miền Nam, VN)',
      story:
          'Gỏi cuốn nổi bật bởi sự thanh mát: bánh tráng cuốn tôm, thịt, bún và rau sống. '
          'Món ít dầu mỡ, phù hợp người thích ăn nhẹ nhưng vẫn đủ chất. '
          'Điểm “ăn tiền” là nước chấm: tương đậu phộng béo bùi hoặc mắm nêm đậm đà tùy khẩu vị. '
          'Cuốn ngon cần chặt tay vừa đủ để không bung, rau tươi và tôm thịt chín tới.',
      ingredients: ['Bánh tráng', 'Tôm', 'Thịt', 'Bún', 'Rau'],
      imageAsset: 'assets/images/goi_cuon.jpg',
    ),
    FoodItem(
      id: 'chaca',
      name: 'Chả Cá Lã Vọng',
      priceRange: '60k - 120k',
      rating: '4.8',
      location: '(Hà Nội, VN)',
      story:
          'Chả cá Lã Vọng là món ăn trứ danh Hà Nội với cá tẩm nghệ rán vàng, ăn cùng thì là và hành lá. '
          'Khi dọn lên, chảo cá vẫn sôi lách tách, thơm nức mùi nghệ và mắm tôm (hoặc nước mắm) tùy chọn. '
          'Ăn kèm bún, lạc rang, rau thơm giúp cân bằng độ béo và tăng hương. '
          'Đây là món phù hợp trải nghiệm “ẩm thực truyền thống” theo phong cách thưởng thức tại bàn.',
      ingredients: ['Cá', 'Nghệ', 'Thì là', 'Hành lá', 'Lạc rang'],
      imageAsset: 'assets/images/cha_ca_la_vong.jpg',
    ),
    FoodItem(
      id: 'hutieu',
      name: 'Hủ Tiếu',
      priceRange: '30k - 50k',
      rating: '4.7',
      location: '(Miền Nam, VN)',
      story:
          'Hủ tiếu có sợi dai mềm đặc trưng, nước dùng ngọt thanh và topping phong phú như thịt, gan, tôm, trứng cút. '
          'Bạn có thể chọn hủ tiếu nước hoặc khô: bản khô trộn sốt, kèm chén nước lèo riêng. '
          'Món ăn hợp khẩu vị nhiều người vì dễ ăn, vị không quá gắt và tùy biến được với chanh, ớt, rau. '
          'Ngon nhất khi sợi vừa chín tới, nước dùng nóng và thơm mùi hành phi.',
      ingredients: ['Hủ tiếu', 'Xương hầm', 'Topping', 'Hành phi', 'Rau'],
      imageAsset: 'assets/images/hu_tieu.jpg',
    ),
    FoodItem(
      id: 'miquang',
      name: 'Mì Quảng',
      priceRange: '30k - 55k',
      rating: '4.8',
      location: '(Quảng Nam, VN)',
      story:
          'Mì Quảng đặc trưng bởi “ít nước nhưng đậm vị”: nước dùng sánh nhẹ, tập trung hương của tôm thịt và gia vị. '
          'Sợi mì vàng, ăn kèm rau sống, bánh tráng mè nướng và đậu phộng rang. '
          'Điểm thú vị là cảm giác giòn của bánh tráng, bùi của lạc và tươi mát của rau hòa với vị đậm đà của nước nhân. '
          'Món này phù hợp người thích trải nghiệm ẩm thực miền Trung rõ nét và hài hòa.',
      ingredients: ['Mì', 'Tôm thịt', 'Rau sống', 'Bánh tráng', 'Lạc rang'],
      imageAsset: 'assets/images/mi_quang.jpg',
    ),
  ];
  
  // Danh sách "Tinh Hoa Phố Phường" (để bấm vào mở chi tiết)
  final List<FoodItem> streetFoods = const [
    FoodItem(
      id: 'banh_xeo',
      name: 'Bánh Xèo',
      priceRange: '20k - 60k',
      rating: '4.8',
      location: '(Miền Trung, VN)',
      story: 'Bánh xèo giòn, nhân tôm thịt, ăn kèm rau sống và nước chấm.',
      ingredients: ['Bột gạo', 'Tôm', 'Thịt', 'Giá', 'Rau sống'],
      imageAsset: 'assets/images/banh_xeo.jpg',
    ),
    FoodItem(
      id: 'com_tam',
      name: 'Cơm Tấm',
      priceRange: '30k - 80k',
      rating: '4.7',
      location: '(TP.HCM, VN)',
      story: 'Cơm tấm sườn bì chả, hương vị đặc trưng Sài Gòn.',
      ingredients: ['Gạo tấm', 'Sườn', 'Bì', 'Chả', 'Đồ chua'],
      imageAsset: 'assets/images/com_tam.jpg',
    ),
    FoodItem(
      id: 'ca_phe_sua_da',
      name: 'Cà Phê Sữa Đá',
      priceRange: '15k - 45k',
      rating: '4.9',
      location: '(Việt Nam)',
      story: 'Cà phê đậm vị kết hợp sữa đặc và đá lạnh – đúng chất Việt.',
      ingredients: ['Cà phê', 'Sữa đặc', 'Đá'],
      imageAsset: 'assets/images/ca_phe_sua_da.jpg',
    ),
    FoodItem(
      id: 'che_ba_mau',
      name: 'Chè Ba Màu',
      priceRange: '10k - 30k',
      rating: '4.6',
      location: '(Miền Nam, VN)',
      story: 'Chè mát lạnh với đậu, thạch và nước cốt dừa.',
      ingredients: ['Đậu đỏ', 'Đậu xanh', 'Thạch', 'Nước cốt dừa'],
      imageAsset: 'assets/images/che_ba_mau.jpg',
    ),
    // ====== THÊM MÓN TINH HOA PHỐ PHƯỜNG ======

FoodItem(
  id: 'banhmiopla',
  name: 'Bánh Mì Ốp La',
  priceRange: '15k - 40k',
  rating: '4.7',
  location: '(Hà Nội, VN)',
  story: 'Bánh mì ốp la nóng giòn, trứng ốp la lên men thơm – món sáng ưa thích của người Việt.',
  ingredients: ['Bánh mì', 'Trứng ốp la', 'Dầu ăn', 'Rau thơm', 'Ớt'],
  imageAsset: 'assets/images/banh_mi_op_la.jpg',
),

FoodItem(
  id: 'banhtrangnuong',
  name: 'Bánh Tráng Nướng',
  priceRange: '20k - 50k',
  rating: '4.5',
  location: '(Đà Lạt, VN)',
  story: 'Bánh tráng nướng giòn, nhân trứng, hành, xúc xích, phô mai – đúng vị ăn vặt vỉa hè.',
  ingredients: ['Bánh tráng', 'Trứng', 'Xúc xích', 'Phô mai', 'Hành'],
  imageAsset: 'assets/images/banh_trang_nuong.jpg',
),

FoodItem(
  id: 'xoiyeu',
  name: 'Xôi Yêu',
  priceRange: '25k - 60k',
  rating: '4.8',
  location: '(Hà Nội, VN)',
  story: 'Xôi dẻo thơm kết hợp topping phong phú: thịt bò, pate, trứng – cực đã miệng.',
  ingredients: ['Xôi', 'Thịt bò', 'Pate', 'Trứng', 'Hành phi'],
  imageAsset: 'assets/images/xoi_yeu.jpg',
),

FoodItem(
  id: 'bohutieu',
  name: 'Bò Hủ Tiếu',
  priceRange: '30k - 70k',
  rating: '4.6',
  location: '(TP.HCM, VN)',
  story: 'Hủ tiếu nước béo thơm, bò xào mềm – món đường phố quen thuộc miền Nam.',
  ingredients: ['Hủ tiếu', 'Thịt bò', 'Nước dùng', 'Hành lá', 'Tiêu'],
  imageAsset: 'assets/images/bo_hu_tieu.jpg',
),

FoodItem(
  id: 'gavilat',
  name: 'Gà Vỉa Hè Lát',
  priceRange: '35k - 90k',
  rating: '4.9',
  location: '(TP.HCM, VN)',
  story: 'Gà nướng vỉa hè thơm lừng, băm lá chanh, cuốn bánh tráng rau sống rất ngon.',
  ingredients: ['Gà', 'Mắm nêm', 'Rau sống', 'Bánh tráng', 'Ớt'],
  imageAsset: 'assets/images/ga_via_he_lat.jpg',
),

FoodItem(
  id: 'banhdaque',
  name: 'Bánh Đa Quế Sơn',
  priceRange: '20k - 45k',
  rating: '4.6',
  location: '(Quảng Nam, VN)',
  story: 'Bánh đa giòn, ăn kèm nước mắm chua ngọt và topping đa dạng thơm ngon.',
  ingredients: ['Bánh đa', 'Tôm khô', 'Đậu phộng', 'Rau thơm', 'Nước mắm'],
  imageAsset: 'assets/images/banh_da_que_son.jpg',
),

FoodItem(
  id: 'banhcanhthu',
  name: 'Bánh Canh Thủ',
  priceRange: '30k - 65k',
  rating: '4.7',
  location: '(Quy Nhơn, VN)',
  story: 'Bánh canh nước trong, topping tôm, thịt – tô nóng giòn miệng phố biển.',
  ingredients: ['Bánh canh', 'Tôm', 'Thịt', 'Hành', 'Tiêu'],
  imageAsset: 'assets/images/banh_canh_thu.jpg',
),

FoodItem(
  id: 'chethai',
  name: 'Chè Thái',
  priceRange: '15k - 40k',
  rating: '4.8',
  location: '(TP.HCM, VN)',
  story: 'Chè Thái mát lạnh, nước cốt dừa béo, topping trái cây đa dạng – cực ngon.',
  ingredients: ['Trái cây', 'Nước cốt dừa', 'Thạch', 'Đậu phộng', 'Đường'],
  imageAsset: 'assets/images/che_thai.jpg',
),

FoodItem(
  id: 'banhxeobaotrung',
  name: 'Bánh Xèo Bảo Trung',
  priceRange: '30k - 60k',
  rating: '4.7',
  location: '(Đà Nẵng, VN)',
  story: 'Bánh xèo giòn rụm, nhân thịt tôm – đặc sản ăn vặt Đà Nẵng đường phố.',
  ingredients: ['Bột gạo', 'Tôm', 'Thịt', 'Giá', 'Rau sống'],
  imageAsset: 'assets/images/banh_xeo_bao_trung.jpg',
),

FoodItem(
  id: 'banhmiotcu',
  name: 'Bánh Mì Ốt Cù',
  priceRange: '18k - 42k',
  rating: '4.5',
  location: '(Hà Nội, VN)',
  story: 'Bánh mì ớt cù cay nồng, ăn kèm pate và đồ chua – phong cách ăn vặt đường phố Hà Nội.',
  ingredients: ['Bánh mì', 'Pate', 'Ớt', 'Dưa góp', 'Rau'],
  imageAsset: 'assets/images/banh_mi_ot_cu.jpg',
),
  ];

  void _openFoodDetail(FoodItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item)),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _openStreetFoodsSeeAll() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StreetFoodsScreen(items: streetFoods),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // ✅ BẤM ICON ĐỎ → PROFILE (UI giữ y)
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: _openProfile,
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  const Text(
                    'Hương Vị Việt',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SEARCH
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm món ăn...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // ===== SEARCH RESULT =====
                    if (_searchQuery.isNotEmpty) ...[
                      Builder(
                        builder: (context) {
                          final allItems = [...foods, ...streetFoods];
                          final results = allItems.where((item) {
                            final q = _searchQuery.toLowerCase();
                            return item.name.toLowerCase().contains(q) ||
                                item.location.toLowerCase().contains(q) ||
                                item.ingredients.join(' ').toLowerCase().contains(q);
                          }).toList();

                          if (results.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text("Không tìm thấy món phù hợp"),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final item = results[index];
                              return ListTile(
                                leading: Image.asset(
                                  item.imageAsset,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(item.name),
                                subtitle: Text(item.location),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FoodDetailScreen(item: item),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                    // REGION
                    Row(
                      children: [
                        // ✅ TAB TẤT CẢ (đang được chọn)
                        _chip('Tất cả', true, () {
                          // Không cần chuyển trang vì đang ở trang tất cả
                        }),

                        _chip('Miền Bắc', false, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RegionFoodsScreen(region: Region.bac, allItems: foods),
                            ),
                          );
                        }),

                        _chip('Miền Trung', false, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RegionFoodsScreen(region: Region.trung, allItems: foods),
                            ),
                          );
                        }),

                        _chip('Miền Nam', false, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RegionFoodsScreen(region: Region.nam, allItems: foods),
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 🔴 TIÊU ĐỀ + XEM TẤT CẢ + MŨI TÊN
                    Row(
                      children: [
                        const Text(
                          'Món Ngon Nổi Bật',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),

                        // XEM TẤT CẢ
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AllFoodsScreen(
                                  items: foods, // ✅ danh sách món nổi bật
                                  initialFilter: RegionFilter.all,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Xem tất cả',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                        // MŨI TÊN
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _scrollLeft,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _scrollRight,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // LIST MÓN (giữ UI, bấm mở chi tiết)
                    SizedBox(
                      height: 210,
                      child: ListView.builder(
                        controller: _foodScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final item = foods[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _openFoodDetail(item),
                            child: _FoodCard(
                              item.name,
                              item.priceRange,
                              item.rating,
                              item.imageAsset, // ✅ thêm dòng này
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ✅ GIỮ UI Y HỆT: chỉ làm "Xem tất cả" bấm được
                    _sectionTitle(
                      text: 'Tinh Hoa Phố Phường',
                      onSeeAll: _openStreetFoodsSeeAll,
                    ),

                    const SizedBox(height: 12),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: streetFoods.map((item) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _openFoodDetail(item), // ✅ bấm vào mở chi tiết
                          child: _CultureCard(item),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RecipeListScreen(),
              ),
            );
            return;
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FavoritesScreenPro(allItems: foods),
              ),
            );
            return;
          }

          if (index == 3) {
            _openProfile();
            return;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Công thức'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Yêu thích'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Cá nhân'),
        ],
      ),
    );
  }

  // ===== WIDGET PHỤ =====

  static Widget _chip(String text, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: selected,
        selectedColor: Colors.red,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }

  // ✅ GIỮ GIAO DIỆN Y HỆT, chỉ đổi "Xem tất cả" từ Text -> bấm được
  static Widget _sectionTitle({
    required String text,
    VoidCallback? onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: const Text(
            'Xem tất cả',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class _FoodCard extends StatelessWidget {
  final String title;
  final String price;
  final String rating;
  final String imageAsset; // ✅ thêm

  const _FoodCard(this.title, this.price, this.rating, this.imageAsset); // ✅ thêm imageAsset

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageAsset, // ✅ đổi từ hardcode sang imageAsset
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: Colors.red)),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(rating),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CultureCard extends StatelessWidget {
  final FoodItem item;

  const _CultureCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(item.imageAsset),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(10),
      child: Text(
        item.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 6),
          ],
        ),
      ),
    );
  }
}