class Menu {
  final String id;
  final String name;
  final int price;
  final String description;
  final String image;

  Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String category;
  final String location;
  final List<Menu> menus;
  final bool hasWheelchairRamp;
  final bool hasAudioMenu;
  final bool allowsGuideDogs;
  final List<String> seatingOptions;
  final String imageUrl;

  Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.menus,
    this.hasWheelchairRamp = false,
    this.hasAudioMenu = false,
    this.allowsGuideDogs = false,
    this.seatingOptions = const ['일반석'],
    required this.imageUrl,
  });
}

class TransportInfo {
  final String id;
  final String method;
  final String mobilityOption;
  final String guideText;
  final String time;
  final bool isVisualImpairmentFriendly;

  TransportInfo({
    required this.id,
    required this.method,
    required this.mobilityOption,
    required this.guideText,
    required this.time,
    this.isVisualImpairmentFriendly = false,
  });
}

// ── Unsplash 음식 전용 이미지 URL ─────────────────────────────────────────────
const String _base = 'https://images.unsplash.com/photo-';
String _u(String id) => '$_base$id?auto=format&fit=crop&w=800&q=80';

// 한식 이미지 IDs
const _imgKalbi      = '1555939594-58d7cb561ad1'; // 갈비구이
const _imgKimchi     = '1580651315530-69c8b763e3f3'; // 김치찌개
const _imgBibimbap   = '1553163147-622ab57be1c7'; // 비빔밥
const _imgSamgyeo    = '1547592166-23ac45744acd'; // 삼겹살
const _imgGukbap     = '1604908176997-125f25cc6f3d'; // 국밥류
const _imgNoodle     = '1569050467447-ce54b3bbc37d'; // 국수/수프류
const _imgRice       = '1434030216411-0b793f4b6f74'; // 밥 요리
const _imgKorFood    = '1498654896293-37aacf113fd9'; // 한식 상차림

// 중식 이미지 IDs
const _imgDumpling   = '1563245372-f21724e3856d'; // 만두/딤섬
const _imgRamen      = '1584949091904-5a6f9f4d2a9e'; // 라멘/짬뽕
const _imgChinese    = '1617093727343-374698b1b08d'; // 중식 요리
const _imgNoodles    = '1585032226651-759b368d7246'; // 국수류
const _imgMalatang   = '1569050467447-ce54b3bbc37d'; // 마라탕

// 양식 이미지 IDs
const _imgSteak      = '1558030006-450675393462'; // 스테이크
const _imgPasta      = '1621996346-ecdbb4e0b5af'; // 파스타
const _imgPizza      = '1565299624946-b28f40a0ae38'; // 피자
const _imgBurger     = '1568901346375-831cd1bbc3bb'; // 버거
const _imgSalmon     = '1519708227418-c8fd9a32b7a2'; // 연어
const _imgRestaurant = '1517248135467-4c7edcad34c4'; // 레스토랑 인테리어
const _imgBrunch     = '1504674900247-0877df9cc836'; // 브런치 플레이트

// 카페 이미지 IDs
const _imgCoffee     = '1495474472287-4d71bcdd2085'; // 커피
const _imgCake       = '1499750310107-5fef28a66643'; // 케이크/디저트
const _imgCafein     = '1554118811-1e0d58224f24'; // 카페 내부
const _imgCroissant  = '1555507036-ab1f4038808a'; // 크루아상
const _imgLatte      = '1461023058943-07fcbe16d735'; // 라떼

// ╔══════════════════════════════════════════════════════════════╗
// ║  한 식 (8개)                                                  ║
// ╚══════════════════════════════════════════════════════════════╝
final List<Restaurant> _korean = [
  Restaurant(
    id: 'h1', name: '일산 칼국수 본점', category: '한식',
    location: '고양시 일산동구 정발산로 12',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['일반석', '휠체어 접근 가능석', '임산부 우대석'],
    imageUrl: _u(_imgNoodle),
    menus: [
      Menu(id: 'h1m1', name: '닭칼국수', price: 11000,
          description: '깊고 진한 닭 육수와 쫄깃한 수타면이 어우러진 일산 대표 명물.',
          image: _u(_imgNoodle)),
      Menu(id: 'h1m2', name: '들깨 수제비', price: 10000,
          description: '구수한 들깨 육수에 쫀득한 수제비를 더한 국물 요리.',
          image: _u(_imgGukbap)),
    ],
  ),
  Restaurant(
    id: 'h2', name: '산들마을 한정식', category: '한식',
    location: '고양시 일산서구 대산로 88',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['온돌방 (좌식)', '입식 일반석', '휠체어 가능 별실'],
    imageUrl: _u(_imgKorFood),
    menus: [
      Menu(id: 'h2m1', name: '한정식 기본 코스', price: 28000,
          description: '계절 나물 반찬·된장찌개·갈비구이·식혜가 한 상 가득.',
          image: _u(_imgKorFood)),
    ],
  ),
  Restaurant(
    id: 'h3', name: '정발산역 설렁탕', category: '한식',
    location: '고양시 일산동구 중앙로 1036',
    seatingOptions: ['일반석'],
    imageUrl: _u(_imgGukbap),
    menus: [
      Menu(id: 'h3m1', name: '특 설렁탕', price: 12000,
          description: '24시간 우린 진한 사골 수육 설렁탕.',
          image: _u(_imgGukbap)),
    ],
  ),
  Restaurant(
    id: 'h4', name: '일산 왕갈비 숯불구이', category: '한식',
    location: '고양시 일산동구 식사동 333',
    hasWheelchairRamp: true,
    seatingOptions: ['숯불 테이블석', '단체 룸', '휠체어 가능석'],
    imageUrl: _u(_imgKalbi),
    menus: [
      Menu(id: 'h4m1', name: '왕왕갈비 1인분 (400g)', price: 32000,
          description: '두툼한 왕갈비를 양념해 숯불 위에 직접 구워드립니다.',
          image: _u(_imgKalbi)),
      Menu(id: 'h4m2', name: '냉면 (물/비빔)', price: 10000,
          description: '갈비구이 후 입가심으로 딱 좋은 평양식 물냉면.',
          image: _u(_imgNoodle)),
    ],
  ),
  Restaurant(
    id: 'h5', name: '호수길 삼겹살&막창', category: '한식',
    location: '고양시 일산동구 호수로 820',
    hasWheelchairRamp: true,
    seatingOptions: ['테이블석', '야외 테라스석'],
    imageUrl: _u(_imgSamgyeo),
    menus: [
      Menu(id: 'h5m1', name: '두꺼운 참숯 삼겹살', price: 16900,
          description: '두툼하게 썬 삼겹살을 참숯에 직접 구워 감칠맛이 최고.',
          image: _u(_imgSamgyeo)),
      Menu(id: 'h5m2', name: '소금구이 막창', price: 12000,
          description: '소금과 참기름에 찍어 먹는 쫄깃한 막창.',
          image: _u(_imgKalbi)),
    ],
  ),
  Restaurant(
    id: 'h6', name: '라페스타 육회비빔밥', category: '한식',
    location: '고양시 일산동구 무궁화로 11',
    hasWheelchairRamp: true, hasAudioMenu: true,
    seatingOptions: ['카운터석', '테이블석', '휠체어석'],
    imageUrl: _u(_imgBibimbap),
    menus: [
      Menu(id: 'h6m1', name: '육회 비빔밥', price: 14000,
          description: '신선한 한우 육회와 채소를 참기름에 비벼 먹는 비빔밥.',
          image: _u(_imgBibimbap)),
    ],
  ),
  Restaurant(
    id: 'h7', name: '일산 순두부찌개 명인', category: '한식',
    location: '고양시 일산서구 주엽동 55-2',
    seatingOptions: ['일반석'],
    imageUrl: _u(_imgKimchi),
    menus: [
      Menu(id: 'h7m1', name: '해물 순두부찌개', price: 9000,
          description: '보들보들한 순두부와 싱싱한 해물이 가득한 얼큰한 찌개.',
          image: _u(_imgKimchi)),
    ],
  ),
  Restaurant(
    id: 'h9', name: '백석동 곰탕 & 해장국', category: '한식',
    location: '고양시 일산동구 백석동 1310',
    hasWheelchairRamp: true,
    seatingOptions: ['일반석', '휠체어 가능석'],
    imageUrl: _u(_imgGukbap),
    menus: [
      Menu(id: 'h9m1', name: '한우 곰탕', price: 13000,
          description: '한우 사골을 12시간 이상 푹 우린 뽀얀 국물의 정통 곰탕.',
          image: _u(_imgGukbap)),
      Menu(id: 'h9m2', name: '선지 해장국', price: 10000,
          description: '진한 우거지와 선지가 어우러져 속을 편안하게 풀어주는 해장국.',
          image: _u(_imgGukbap)),
    ],
  ),
  Restaurant(
    id: 'h10', name: '마두역 닭갈비 & 막국수', category: '한식',
    location: '고양시 일산동구 마두동 803',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['철판 테이블석', '단체 룸', '휠체어석'],
    imageUrl: _u(_imgSamgyeo),
    menus: [
      Menu(id: 'h10m1', name: '춘천식 철판 닭갈비 (2인)', price: 26000,
          description: '고추장 양념에 재운 닭고기를 넓은 철판에 채소와 함께 볶아냅니다.',
          image: _u(_imgKalbi)),
      Menu(id: 'h10m2', name: '메밀 막국수', price: 9000,
          description: '100% 메밀로 뽑은 면에 동치미 육수를 더한 강원도식 막국수.',
          image: _u(_imgNoodle)),
    ],
  ),
  Restaurant(
    id: 'h8', name: '킨텍스 돌솥비빔밥', category: '한식',
    location: '고양시 일산서구 킨텍스로 217',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['일반석', '휠체어 가능석', '패밀리 부스'],
    imageUrl: _u(_imgBibimbap),
    menus: [
      Menu(id: 'h8m1', name: '돌솥 비빔밥', price: 11000,
          description: '뜨거운 돌솥에 눌린 누룽지까지 즐길 수 있는 전통 비빔밥.',
          image: _u(_imgBibimbap)),
    ],
  ),
];

// ╔══════════════════════════════════════════════════════════════╗
// ║  중 식 (5개)                                                  ║
// ╚══════════════════════════════════════════════════════════════╝
final List<Restaurant> _chinese = [
  Restaurant(
    id: 'c1', name: '레이킨스몰 고급 중화요리', category: '중식',
    location: '고양시 일산동구 장항동 877',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['원형 테이블석', '가족석 (6인)', '휠체어 접견 가능석'],
    imageUrl: _u(_imgChinese),
    menus: [
      Menu(id: 'c1m1', name: '깐풍기', price: 22000,
          description: '바삭하게 튀긴 닭에 매콤달콤한 깐풍 소스를 곁들인 중식의 정석.',
          image: _u(_imgChinese)),
      Menu(id: 'c1m2', name: '홍소육', price: 35000,
          description: '장시간 삶은 돼지고기를 간장·오향 소스로 마무리한 고급 요리.',
          image: _u(_imgChinese)),
    ],
  ),
  Restaurant(
    id: 'c2', name: '일산 짬뽕 명가', category: '중식',
    location: '고양시 일산동구 성석동 215-1',
    hasWheelchairRamp: true,
    seatingOptions: ['일반석', '휠체어 가능석'],
    imageUrl: _u(_imgRamen),
    menus: [
      Menu(id: 'c2m1', name: '불짬뽕', price: 13000,
          description: '직화로 볶은 해물과 채소가 가득한 진하고 칼칼한 국물.',
          image: _u(_imgRamen)),
      Menu(id: 'c2m2', name: '삼선짜장면', price: 12000,
          description: '해삼·새우·오징어가 들어간 풍성한 삼선 짜장면.',
          image: _u(_imgNoodles)),
    ],
  ),
  Restaurant(
    id: 'c3', name: '차이나타운 딤섬하우스', category: '중식',
    location: '고양시 일산동구 중앙로 1252',
    hasWheelchairRamp: true, hasAudioMenu: true,
    seatingOptions: ['라운드 테이블', '창가석', '휠체어석'],
    imageUrl: _u(_imgDumpling),
    menus: [
      Menu(id: 'c3m1', name: '새우 하가우 (4피스)', price: 9000,
          description: '탱글탱글한 새우가 가득 담긴 홍콩식 딤섬의 대표 메뉴.',
          image: _u(_imgDumpling)),
      Menu(id: 'c3m2', name: '차슈 바오 (3피스)', price: 8000,
          description: '부드러운 빵 안에 달콤한 차슈 돼지고기를 넣은 쪄낸 만두.',
          image: _u(_imgDumpling)),
    ],
  ),
  Restaurant(
    id: 'c4', name: '정발산 양꼬치&마라탕', category: '중식',
    location: '고양시 일산동구 정발산로 101',
    seatingOptions: ['일반석'],
    imageUrl: _u(_imgMalatang),
    menus: [
      Menu(id: 'c4m1', name: '양꼬치 10개', price: 15000,
          description: '향신료에 재운 양고기를 숯불에 구워 입안 가득 향긋함.',
          image: _u(_imgKalbi)),
      Menu(id: 'c4m2', name: '마라탕 (중)', price: 14000,
          description: '마라 육수에 원하는 재료를 넣어 끓인 얼얼하고 향긋한 탕.',
          image: _u(_imgMalatang)),
    ],
  ),
  Restaurant(
    id: 'c6', name: '일산 북경오리 전문점', category: '중식',
    location: '고양시 일산동구 중앙로 1158',
    hasWheelchairRamp: true, hasAudioMenu: true,
    seatingOptions: ['원형 테이블석', '가족 룸', '휠체어석'],
    imageUrl: _u(_imgChinese),
    menus: [
      Menu(id: 'c6m1', name: '베이징 덕 (반 마리)', price: 38000,
          description: '바삭한 껍질과 촉촉한 살코기를 얇은 전병에 오이·파와 싸먹는 북경 요리.',
          image: _u(_imgChinese)),
      Menu(id: 'c6m2', name: '마파두부', price: 13000,
          description: '두반장과 산초로 만든 얼얼하고 깊은 맛의 정통 쓰촨 마파두부.',
          image: _u(_imgChinese)),
    ],
  ),
  Restaurant(
    id: 'c7', name: '대화동 탄탄면 & 샤오롱바오', category: '중식',
    location: '고양시 일산서구 대화동 2134',
    hasWheelchairRamp: true,
    seatingOptions: ['일반석', '창가석', '휠체어 가능석'],
    imageUrl: _u(_imgRamen),
    menus: [
      Menu(id: 'c7m1', name: '쓰촨 탄탄면', price: 12000,
          description: '깨 소스와 매운 고추기름을 뿌린 고소하고 칼칼한 국수.',
          image: _u(_imgRamen)),
      Menu(id: 'c7m2', name: '샤오롱바오 (6피스)', price: 11000,
          description: '육즙이 가득한 상하이식 찐 만두, 생강 식초와 함께.',
          image: _u(_imgDumpling)),
    ],
  ),
  Restaurant(
    id: 'c8', name: '풍동 홍콩 완탕면', category: '중식',
    location: '고양시 일산동구 풍동 399-1',
    hasAudioMenu: true,
    seatingOptions: ['카운터석', '2인 테이블'],
    imageUrl: _u(_imgNoodles),
    menus: [
      Menu(id: 'c8m1', name: '새우 완탕면', price: 12000,
          description: '탱글한 새우살 완탕과 홍콩식 달걀 국수를 깔끔한 육수에 담아냈습니다.',
          image: _u(_imgNoodles)),
      Menu(id: 'c8m2', name: '차슈 볶음밥', price: 11000,
          description: '불 맛 가득한 웍에 구运 차슈와 달걀로 볶아낸 홍콩식 볶음밥.',
          image: _u(_imgRice)),
    ],
  ),
  Restaurant(
    id: 'c9', name: '킨텍스 고급 광동요리', category: '중식',
    location: '고양시 일산서구 킨텍스로 222',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['프라이빗 룸', '원형 연회석', '휠체어 전용석'],
    imageUrl: _u(_imgChinese),
    menus: [
      Menu(id: 'c9m1', name: '광동식 해산물 볶음', price: 42000,
          description: '랍스터·가리비·새우를 굴소스와 함께 고화력 웍에 빠르게 볶은 광동 요리.',
          image: _u(_imgChinese)),
      Menu(id: 'c9m2', name: '딤섬 코스 (4종)', price: 28000,
          description: '하가우·차슈바오·에그타르트·춘권 4가지를 한 번에 즐기는 코스.',
          image: _u(_imgDumpling)),
    ],
  ),
  Restaurant(
    id: 'c10', name: '백석역 유산슬 & 팔보채', category: '중식',
    location: '고양시 일산동구 백석동 1217',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['일반석', '단체 룸', '휠체어석'],
    imageUrl: _u(_imgChinese),
    menus: [
      Menu(id: 'c10m1', name: '유산슬', price: 32000,
          description: '해삼·전복·새우 등 8가지 해산물을 굴소스에 볶은 프리미엄 중식.',
          image: _u(_imgChinese)),
      Menu(id: 'c10m2', name: '팔보채', price: 30000,
          description: '문어·해삼·낙지 등 팔가지 진귀한 재료를 넣은 고급 볶음 요리.',
          image: _u(_imgChinese)),
    ],
  ),
  Restaurant(
    id: 'c5', name: '대림중화요리', category: '중식',
    location: '고양시 일산서구 주엽동 115',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['일반석', '단체 룸', '휠체어석'],
    imageUrl: _u(_imgChinese),
    menus: [
      Menu(id: 'c5m1', name: '간짜장', price: 11000,
          description: '볶은 춘장에 채소와 고기를 넣어 꾸덕하게 만든 정통 간짜장.',
          image: _u(_imgNoodles)),
    ],
  ),
];

// ╔══════════════════════════════════════════════════════════════╗
// ║  양 식 (5개)                                                  ║
// ╚══════════════════════════════════════════════════════════════╝
final List<Restaurant> _western = [
  Restaurant(
    id: 'w1', name: '라페스타 비스트로', category: '양식',
    location: '고양시 일산동구 무궁화로 32',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['창가석', '일반석', '휠체어석 (테이블 높이 조절)'],
    imageUrl: _u(_imgRestaurant),
    menus: [
      Menu(id: 'w1m1', name: '트러플 크림 파스타', price: 24000,
          description: '신선한 트러플 오일과 진한 크림 소스가 어우러진 부드러운 파스타.',
          image: _u(_imgPasta)),
      Menu(id: 'w1m2', name: '그릴드 연어 스테이크', price: 32000,
          description: '노르웨이산 연어를 그릴에 구워 레몬 버터 소스와 서빙.',
          image: _u(_imgSalmon)),
    ],
  ),
  Restaurant(
    id: 'w2', name: '정발산 스테이크하우스', category: '양식',
    location: '고양시 일산동구 정발산로 45',
    hasWheelchairRamp: true,
    seatingOptions: ['부스 좌석', '테이블석', '휠체어 편의석'],
    imageUrl: _u(_imgSteak),
    menus: [
      Menu(id: 'w2m1', name: 'US 등심 (200g)', price: 48000,
          description: '미국산 초이스 등심 드라이에이징 후 철판에 구워 최상의 풍미.',
          image: _u(_imgSteak)),
    ],
  ),
  Restaurant(
    id: 'w3', name: '일산 피자&파스타 팩토리', category: '양식',
    location: '고양시 일산서구 대화동 2201',
    hasWheelchairRamp: true,
    seatingOptions: ['패밀리 테이블', '창가석', '휠체어석'],
    imageUrl: _u(_imgPizza),
    menus: [
      Menu(id: 'w3m1', name: '시그니처 마르게리타', price: 19000,
          description: '신선한 바질·모차렐라·토마토 소스의 나폴리탄 정통 피자.',
          image: _u(_imgPizza)),
      Menu(id: 'w3m2', name: '보로네제 파스타', price: 18000,
          description: '소고기 미트 소스를 8시간 졸인 진하고 깊은 볼로냐식 파스타.',
          image: _u(_imgPasta)),
    ],
  ),
  Restaurant(
    id: 'w4', name: '킨텍스 브런치&버거', category: '양식',
    location: '고양시 일산서구 킨텍스로 200',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['인사이드석', '야외 텐트석', '휠체어 전용 테이블'],
    imageUrl: _u(_imgBrunch),
    menus: [
      Menu(id: 'w4m1', name: '아보카도 에그 베네딕트', price: 16000,
          description: '신선한 아보카도와 수란을 올린 브런치의 정석.',
          image: _u(_imgBrunch)),
      Menu(id: 'w4m2', name: '더블 스모키 버거', price: 17000,
          description: '두툼한 수제 패티에 스모키 BBQ 소스를 더한 시그니처 버거.',
          image: _u(_imgBurger)),
    ],
  ),
  Restaurant(
    id: 'w6', name: '대화동 프렌치 비스트로', category: '양식',
    location: '고양시 일산서구 대화동 2205',
    hasWheelchairRamp: true, hasAudioMenu: true,
    seatingOptions: ['창가 2인석', '테이블석', '휠체어 접근 테이블'],
    imageUrl: _u(_imgRestaurant),
    menus: [
      Menu(id: 'w6m1', name: '오리 꽁피 & 감자 그라탱', price: 34000,
          description: '저온에서 천천히 익힌 오리 다리와 크림 감자 그라탱의 완벽한 조합.',
          image: _u(_imgSteak)),
      Menu(id: 'w6m2', name: '부야베스 (2인)', price: 54000,
          description: '홍합·새우·흰 살 생선을 사프란 육수에 끓인 남프랑스 해물 수프.',
          image: _u(_imgSalmon)),
    ],
  ),
  Restaurant(
    id: 'w7', name: '백석동 멕시칸 타코 바', category: '양식',
    location: '고양시 일산동구 백석동 1255',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['바 카운터석', '테이블석', '휠체어석'],
    imageUrl: _u(_imgBurger),
    menus: [
      Menu(id: 'w7m1', name: '트리플 타코 세트', price: 18000,
          description: '수제 또르티야에 카르니타스·살사·아보카도를 올린 시그니처 타코 3개.',
          image: _u(_imgBurger)),
      Menu(id: 'w7m2', name: '나초 플레터', price: 15000,
          description: '바삭한 나초에 체다 치즈·과카몰레·사워크림을 듬뿍 올린 파티 플레터.',
          image: _u(_imgBrunch)),
    ],
  ),
  Restaurant(
    id: 'w8', name: '탄현동 그리스 지중해 식당', category: '양식',
    location: '고양시 일산서구 탄현동 511',
    hasWheelchairRamp: true,
    seatingOptions: ['야외 테라스석', '실내 홀', '휠체어 테이블'],
    imageUrl: _u(_imgRestaurant),
    menus: [
      Menu(id: 'w8m1', name: '그릭 샐러드 & 수블라키', price: 22000,
          description: '올리브·페타치즈 샐러드와 돼지고기 꼬치를 함께 즐기는 그리스 정식.',
          image: _u(_imgSalmon)),
      Menu(id: 'w8m2', name: '무사카', price: 19000,
          description: '가지·감자·다진 고기를 층층이 쌓아 베샤멜 소스를 덮어 구운 그리스 전통 요리.',
          image: _u(_imgBrunch)),
    ],
  ),
  Restaurant(
    id: 'w9', name: '풍산동 아메리칸 BBQ 하우스', category: '양식',
    location: '고양시 일산서구 풍산동 292',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['넓은 홀 테이블', '단체 부스', '휠체어 전용 테이블'],
    imageUrl: _u(_imgSteak),
    menus: [
      Menu(id: 'w9m1', name: '폭립 풀 랙', price: 52000,
          description: '12시간 훈연한 돼지 폭립을 직화로 마무리한 미국식 정통 BBQ.',
          image: _u(_imgSteak)),
      Menu(id: 'w9m2', name: '스모키 베이컨 치즈버거', price: 19000,
          description: '숯불 수제 패티에 스모키 베이컨과 아메리칸 치즈를 두 겹으로 올린 버거.',
          image: _u(_imgBurger)),
    ],
  ),
  Restaurant(
    id: 'w10', name: '마두동 스패니시 타파스', category: '양식',
    location: '고양시 일산동구 마두동 776',
    hasWheelchairRamp: true,
    seatingOptions: ['바 좌석', '테이블석', '휠체어석'],
    imageUrl: _u(_imgRestaurant),
    menus: [
      Menu(id: 'w10m1', name: '하몽 이베리코 & 치즈 플레터', price: 28000,
          description: '이베리코 돼지로 만든 하몽과 스페인 치즈 3종을 올리브와 함께.',
          image: _u(_imgSalmon)),
      Menu(id: 'w10m2', name: '해물 빠에야 (2인)', price: 36000,
          description: '사프란 향 가득한 스페인 전통 해물 빠에야, 새우·홍합·오징어.',
          image: _u(_imgRestaurant)),
    ],
  ),
  Restaurant(
    id: 'w5', name: '호수공원 이탈리안 레스토랑', category: '양식',
    location: '고양시 일산동구 호수로 672',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['테라스 뷰석', '실내 조명 좌석', '휠체어 서비스 테이블'],
    imageUrl: _u(_imgRestaurant),
    menus: [
      Menu(id: 'w5m1', name: '리조또 알라 밀라네제', price: 22000,
          description: '사프란 향이 가득한 크리미한 밀라노 스타일 리조또.',
          image: _u(_imgPasta)),
      Menu(id: 'w5m2', name: '티라미수', price: 8000,
          description: '마스카포네와 에스프레소의 달콤한 이탈리안 디저트.',
          image: _u(_imgCake)),
    ],
  ),
];

// ╔══════════════════════════════════════════════════════════════╗
// ║  카 페 (4개)                                                  ║
// ╚══════════════════════════════════════════════════════════════╝
final List<Restaurant> _cafe = [
  Restaurant(
    id: 'k1', name: '호수공원 앞 카페 테라스', category: '카페',
    location: '고양시 일산동구 호수로 595',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['야외 테라스석', '조용한 내부석', '휠체어 전용 라운지'],
    imageUrl: _u(_imgCafein),
    menus: [
      Menu(id: 'k1m1', name: '시그니처 드립 커피 & 케이크 세트', price: 15000,
          description: '호수뷰를 바라보며 즐기는 여유로운 오후의 커피 한 잔.',
          image: _u(_imgCoffee)),
    ],
  ),
  Restaurant(
    id: 'k2', name: '정발산 스페셜티 커피', category: '카페',
    location: '고양시 일산동구 정발산로 77',
    hasWheelchairRamp: true,
    seatingOptions: ['바 카운터석', '테이블석', '휠체어 가능석'],
    imageUrl: _u(_imgCoffee),
    menus: [
      Menu(id: 'k2m1', name: '싱글 오리진 핸드드립', price: 7500,
          description: '에티오피아·과테말라 원두를 선택해 직접 추출하는 정통 핸드드립.',
          image: _u(_imgLatte)),
    ],
  ),
  Restaurant(
    id: 'k3', name: '라페스타 디저트 카페', category: '카페',
    location: '고양시 일산동구 무궁화로 50',
    hasWheelchairRamp: true, hasAudioMenu: true,
    seatingOptions: ['2인 테이블', '소파석', '휠체어 공간'],
    imageUrl: _u(_imgCake),
    menus: [
      Menu(id: 'k3m1', name: '딸기 생크림 케이크', price: 8500,
          description: '매일 아침 직접 만드는 생크림과 계절 딸기로 감싼 케이크.',
          image: _u(_imgCake)),
      Menu(id: 'k3m2', name: '아이스 아메리카노', price: 5000,
          description: '깔끔하고 진한 에스프레소 샷을 차갑게 즐기는 아메리카노.',
          image: _u(_imgCoffee)),
    ],
  ),
  Restaurant(
    id: 'k5', name: '백석동 북유럽 스타일 카페', category: '카페',
    location: '고양시 일산동구 백석동 1308',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['소파 라운지', '창가 1인석', '휠체어 전용 공간'],
    imageUrl: _u(_imgCafein),
    menus: [
      Menu(id: 'k5m1', name: '오트밀크 라떼', price: 6500,
          description: '부드러운 오트밀크와 에스프레소를 조화롭게 섞은 비건 라떼.',
          image: _u(_imgLatte)),
      Menu(id: 'k5m2', name: '시나몬 카다멈 롤', price: 5500,
          description: '북유럽 전통 방식으로 구운 촉촉한 계피·카다멈 시나몬 롤.',
          image: _u(_imgCroissant)),
    ],
  ),
  Restaurant(
    id: 'k6', name: '마두동 일몰 루프탑 카페', category: '카페',
    location: '고양시 일산동구 마두동 780',
    hasWheelchairRamp: true,
    seatingOptions: ['루프탑 야외석', '실내 홀', '휠체어 엘리베이터 이용 가능'],
    imageUrl: _u(_imgCafein),
    menus: [
      Menu(id: 'k6m1', name: '시그니처 선셋 에이드', price: 7000,
          description: '자몽·패션프루트·탄산수를 섞은 루프탑 전용 시그니처 에이드.',
          image: _u(_imgLatte)),
      Menu(id: 'k6m2', name: '크렘 브뤼레', price: 7500,
          description: '바삭한 카라멜 크러스트 아래 부드럽고 진한 바닐라 커스터드.',
          image: _u(_imgCake)),
    ],
  ),
  Restaurant(
    id: 'k7', name: '대화동 책과 커피 서점 카페', category: '카페',
    location: '고양시 일산서구 대화동 2336',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['독서 1인석', '그룹 테이블', '휠체어 전용 열람석'],
    imageUrl: _u(_imgCoffee),
    menus: [
      Menu(id: 'k7m1', name: '콜드브루 토닉', price: 6500,
          description: '18시간 추출 콜드브루를 토닉워터와 레몬 슬라이스로 완성한 청량감.',
          image: _u(_imgCoffee)),
      Menu(id: 'k7m2', name: '바스크 치즈케이크', price: 7000,
          description: '겉은 진하게 타고 속은 부드럽게 녹는 스페인 바스크 스타일 케이크.',
          image: _u(_imgCake)),
    ],
  ),
  Restaurant(
    id: 'k8', name: '풍산동 플라워 티 하우스', category: '카페',
    location: '고양시 일산서구 풍산동 281',
    hasWheelchairRamp: true, hasAudioMenu: true,
    seatingOptions: ['가든 테라스석', '실내 소파석', '휠체어 가능석'],
    imageUrl: _u(_imgCafein),
    menus: [
      Menu(id: 'k8m1', name: '로즈 얼그레이 밀크티', price: 7000,
          description: '장미 꽃잎을 더한 얼그레이를 진하게 우려 따뜻한 밀크티로 즐깁니다.',
          image: _u(_imgLatte)),
      Menu(id: 'k8m2', name: '마들렌 3종 세트', price: 6000,
          description: '바닐라·레몬·초코 세 가지 마들렌을 한 번에 즐기는 디저트 세트.',
          image: _u(_imgCake)),
    ],
  ),
  Restaurant(
    id: 'k9', name: '탄현동 로스터리 커피 랩', category: '카페',
    location: '고양시 일산서구 탄현동 488',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['바 좌석', '테이블석', '휠체어 가능석'],
    imageUrl: _u(_imgCoffee),
    menus: [
      Menu(id: 'k9m1', name: '당일 로스팅 드립백 세트 (3개)', price: 13500,
          description: '매일 직접 로스팅한 싱글 오리진 원두로 만든 드립백 3종 세트.',
          image: _u(_imgCoffee)),
      Menu(id: 'k9m2', name: '플랫화이트', price: 5500,
          description: '진한 리스트레토 더블샷에 부드러운 마이크로폼을 올린 호주식 커피.',
          image: _u(_imgLatte)),
    ],
  ),
  Restaurant(
    id: 'k10', name: '호수공원 디저트 & 와플 스튜디오', category: '카페',
    location: '고양시 일산동구 호수로 603',
    hasWheelchairRamp: true, hasAudioMenu: true, allowsGuideDogs: true,
    seatingOptions: ['야외 피크닉 테이블', '실내 홀', '휠체어 전용 라운지'],
    imageUrl: _u(_imgCake),
    menus: [
      Menu(id: 'k10m1', name: '버블 와플 아이스크림', price: 9000,
          description: '홍콩식 에그와플에 프리미엄 아이스크림 2스쿱을 올린 시그니처 디저트.',
          image: _u(_imgCake)),
      Menu(id: 'k10m2', name: '말차 라떼 & 앙버터 크레이프', price: 13000,
          description: '진한 말차 라떼와 촉촉한 앙버터 크레이프의 인기 세트 조합.',
          image: _u(_imgLatte)),
    ],
  ),
  Restaurant(
    id: 'k4', name: '킨텍스 베이커리 & 카페', category: '카페',
    location: '고양시 일산서구 킨텍스로 215',
    hasWheelchairRamp: true, allowsGuideDogs: true,
    seatingOptions: ['넓은 홀 테이블', '창가석', '보행 보조 안내 동선'],
    imageUrl: _u(_imgCroissant),
    menus: [
      Menu(id: 'k4m1', name: '크루아상 샌드위치', price: 9000,
          description: '바삭한 버터 크루아상에 햄·치즈·채소를 가득 채운 프리미엄 샌드위치.',
          image: _u(_imgCroissant)),
    ],
  ),
];

// ── 전체 목록 ─────────────────────────────────────────────────────────────────
final List<Restaurant> mockRestaurants = [
  ..._korean,
  ..._chinese,
  ..._western,
  ..._cafe,
];

// ── 교통 정보 ─────────────────────────────────────────────────────────────────
final List<TransportInfo> mockTransportData = [
  TransportInfo(
    id: 't1', method: '1000번 버스 (저상/BRT)',
    mobilityOption: '저상버스 운행 중 (휠체어석 2자리, 자동 경사로)',
    guideText: '잠시 후 정발산역 앞 중앙차로 정류장에 도착합니다. 하차 시 단차에 주의해 주세요.',
    time: '12분',
  ),
  TransportInfo(
    id: 't2', method: '지하철 3호선 정발산역',
    mobilityOption: '2번 출구 엘리베이터 정상 가동, 내부 점자 블록 완비',
    guideText: '엘리베이터는 개찰구를 통과하여 우측으로 약 50미터 앞에 있습니다. 점자 안내 블록을 따라 이동해 주세요.',
    time: '20분',
    isVisualImpairmentFriendly: true,
  ),
  TransportInfo(
    id: 't3', method: '고양시 시각장애인 생활이동지원센터',
    mobilityOption: '시각장애인 전용 이동지원 차량 즉시 호출 가능 (무료)',
    guideText: '차량이 배차되었습니다. 출발지 앞에서 기다려 주시면 기사님이 직접 안내해 드립니다.',
    time: '10분 이내',
    isVisualImpairmentFriendly: true,
  ),
  TransportInfo(
    id: 't4', method: '일산 교통약자 이동지원센터 (콜택시)',
    mobilityOption: '리프트 장착 차량 운행, 휠체어·유모차 탑승 가능',
    guideText: '기사님이 배차되었습니다. 목적지까지 안전하게 모시겠습니다.',
    time: '5분 내 도착',
  ),
];

final List<String> mockCategories = ['전체', '한식', '중식', '양식', '카페'];
