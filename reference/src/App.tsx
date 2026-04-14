/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  Search, 
  MapPin, 
  ChevronLeft, 
  Minus, 
  Plus, 
  Bus, 
  Volume2, 
  Navigation,
  X,
  CheckCircle2,
  Info
} from 'lucide-react';

// --- Types ---
interface Menu {
  id: string;
  name: string;
  price: number;
  description: string;
  image: string;
}

interface Restaurant {
  id: string;
  name: string;
  category: string;
  location: string;
  menus: Menu[];
  coords: { x: number; y: number };
}

interface TransportInfo {
  id: string;
  method: string;
  mobilityOption: string;
  guideText: string;
  time: string;
}

// --- Dummy Data ---
const RESTAURANTS: Restaurant[] = [
  {
    id: '1',
    name: '테스트 식당 (강남점)',
    category: '양식',
    location: '서울시 강남구 테헤란로 123',
    coords: { x: 30, y: 40 },
    menus: [
      {
        id: 'm1',
        name: 'Tartufo Eggs',
        price: 48000,
        description: 'Fluffy scrambled eggs with chives, togarashi, Sakura mix, and a hint of honey, served on toast with a drizzle of truffle oil.',
        image: 'https://picsum.photos/seed/eggs/600/400'
      }
    ]
  },
  {
    id: '2',
    name: '맛있는 한식당',
    category: '한식',
    location: '서울시 서초구 반포대로 45',
    coords: { x: 60, y: 25 },
    menus: []
  },
  {
    id: '3',
    name: '중화요리 본가',
    category: '중식',
    location: '서울시 송파구 올림픽로 78',
    coords: { x: 75, y: 65 },
    menus: []
  }
];

const TRANSPORT_DATA: TransportInfo[] = [
  {
    id: 't1',
    method: '간선 버스 143',
    mobilityOption: '저상버스 운영 중 (휠체어 탑승 가능)',
    guideText: '잠시 후 우회전입니다. 횡단보도 앞에서 멈춰주세요.',
    time: '15분'
  },
  {
    id: 't2',
    method: '지하철 2호선',
    mobilityOption: '엘리베이터 및 휠체어 리프트 완비',
    guideText: '출구 방향 엘리베이터는 3번 출구 인근에 있습니다.',
    time: '22분'
  }
];

const CATEGORIES = ['전체', '한식', '중식', '양식', '일식', '카페'];

// --- Components ---

const MobileFrame = ({ children }: { children: React.ReactNode }) => (
  <div className="flex items-center justify-center min-h-screen bg-gray-100 p-4">
    <div className="relative w-full max-w-[375px] h-[812px] bg-white rounded-[3rem] shadow-2xl overflow-hidden border-[8px] border-gray-800">
      {/* Notch */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-40 h-7 bg-gray-800 rounded-b-2xl z-50 flex items-end justify-center pb-1">
        <div className="w-12 h-1 bg-gray-700 rounded-full mb-1"></div>
      </div>
      {/* Content */}
      <div className="h-full w-full overflow-y-auto scrollbar-hide bg-gray-50">
        {children}
      </div>
    </div>
  </div>
);

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<'map' | 'menu' | 'transport'>('map');
  const [selectedRestaurant, setSelectedRestaurant] = useState<Restaurant>(RESTAURANTS[0]);
  const [quantity, setQuantity] = useState(1);
  const [eggStyle, setEggStyle] = useState('Scrambled');
  const [showToast, setShowToast] = useState(false);

  const handleMarkerClick = (restaurant: Restaurant) => {
    setSelectedRestaurant(restaurant);
    setCurrentScreen('menu');
  };

  const handleAddToCart = () => {
    setShowToast(true);
    setTimeout(() => {
      setShowToast(false);
      setCurrentScreen('transport');
    }, 2000);
  };

  const speak = (text: string) => {
    if ('speechSynthesis' in window) {
      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = 'ko-KR';
      window.speechSynthesis.speak(utterance);
    }
  };

  return (
    <MobileFrame>
      <AnimatePresence mode="wait">
        {currentScreen === 'map' && (
          <Screen1 key="map" onMarkerClick={handleMarkerClick} />
        )}
        {currentScreen === 'menu' && (
          <Screen2 
            key="menu" 
            restaurant={selectedRestaurant} 
            quantity={quantity}
            setQuantity={setQuantity}
            eggStyle={eggStyle}
            setEggStyle={setEggStyle}
            onBack={() => setCurrentScreen('map')}
            onConfirm={handleAddToCart}
          />
        )}
        {currentScreen === 'transport' && (
          <Screen3 
            key="transport" 
            restaurant={selectedRestaurant} 
            onSpeak={speak}
            onBack={() => setCurrentScreen('menu')}
          />
        )}
      </AnimatePresence>

      {/* Toast Notification */}
      <AnimatePresence>
        {showToast && (
          <motion.div 
            initial={{ opacity: 0, y: 50 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 50 }}
            className="absolute bottom-24 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-6 py-3 rounded-full shadow-lg z-[100] flex items-center gap-2 whitespace-nowrap"
          >
            <CheckCircle2 className="w-5 h-5 text-green-400" />
            <span className="text-sm font-medium">예약이 완료되었습니다!</span>
          </motion.div>
        )}
      </AnimatePresence>
    </MobileFrame>
  );
}

// --- Screen 1: Map & Search ---
function Screen1({ onMarkerClick }: { onMarkerClick: (r: Restaurant) => void; key?: string }) {
  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="flex flex-col h-full"
    >
      {/* Header */}
      <div className="p-4 pt-12 bg-white shadow-sm z-10">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
          <input 
            type="text" 
            placeholder="식당 또는 메뉴 검색"
            aria-label="식당 또는 메뉴 검색"
            className="w-full pl-10 pr-4 py-3 bg-gray-100 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400 transition-all"
          />
        </div>
        
        <div className="flex gap-2 mt-4 overflow-x-auto scrollbar-hide pb-1">
          {CATEGORIES.map((cat) => (
            <button
              key={cat}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${
                cat === '전체' ? 'bg-yellow-400 text-gray-900' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      {/* Map Area */}
      <div className="flex-1 relative bg-gray-200 overflow-hidden">
        {/* Dummy Map Background */}
        <div className="absolute inset-0 bg-[radial-gradient(#d1d5db_1px,transparent_1px)] [background-size:20px_20px] opacity-50"></div>
        
        {RESTAURANTS.map((r) => (
          <motion.button
            key={r.id}
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.9 }}
            onClick={() => onMarkerClick(r)}
            style={{ left: `${r.coords.x}%`, top: `${r.coords.y}%` }}
            className="absolute -translate-x-1/2 -translate-y-1/2 flex flex-col items-center group"
            aria-label={`${r.name} 식당 마커. 클릭하여 메뉴 보기`}
          >
            <div className="bg-white px-2 py-1 rounded shadow-md text-[10px] font-bold mb-1 opacity-0 group-hover:opacity-100 transition-opacity">
              {r.name}
            </div>
            <div className="relative">
              <MapPin className="w-8 h-8 text-red-500 fill-red-200" />
              <div className="absolute inset-0 animate-ping bg-red-400 rounded-full opacity-20"></div>
            </div>
          </motion.button>
        ))}

        <div className="absolute bottom-6 left-1/2 -translate-x-1/2 bg-white/90 backdrop-blur px-4 py-2 rounded-full shadow-lg border border-gray-200 flex items-center gap-2">
          <Navigation className="w-4 h-4 text-blue-500" />
          <span className="text-xs font-medium text-gray-600">현재 위치: 서울시 강남구</span>
        </div>
      </div>
    </motion.div>
  );
}

// --- Screen 2: Menu Detail ---
function Screen2({ 
  restaurant, 
  quantity, 
  setQuantity, 
  eggStyle, 
  setEggStyle, 
  onBack, 
  onConfirm 
}: { 
  restaurant: Restaurant;
  quantity: number;
  setQuantity: (q: number) => void;
  eggStyle: string;
  setEggStyle: (s: string) => void;
  onBack: () => void;
  onConfirm: () => void;
  key?: string;
}) {
  const menu = restaurant.menus[0] || RESTAURANTS[0].menus[0];
  const styles = ['Scrambled', 'Boiled', 'Poached', 'Omelet'];

  return (
    <motion.div 
      initial={{ x: '100%' }}
      animate={{ x: 0 }}
      exit={{ x: '100%' }}
      transition={{ type: 'spring', damping: 25, stiffness: 200 }}
      className="flex flex-col h-full bg-white"
    >
      {/* Hero Image */}
      <div className="relative h-[300px] w-full">
        <img 
          src={menu.image} 
          alt={menu.name}
          className="w-full h-full object-cover"
          referrerPolicy="no-referrer"
        />
        <button 
          onClick={onBack}
          aria-label="뒤로 가기"
          className="absolute top-12 left-4 w-10 h-10 bg-white/80 backdrop-blur rounded-full flex items-center justify-center shadow-md hover:bg-white transition-colors"
        >
          <X className="w-6 h-6 text-gray-800" />
        </button>
      </div>

      {/* Menu Info */}
      <div className="p-6 flex-1">
        <div className="flex justify-between items-start mb-2">
          <h1 className="text-2xl font-bold text-gray-900">{menu.name}</h1>
          <span className="text-xl font-bold text-gray-900">₭ {(menu.price / 1000).toFixed(2)}</span>
        </div>
        <p className="text-gray-500 text-sm leading-relaxed mb-8">
          {menu.description}
        </p>

        {/* Options */}
        <div className="bg-gray-50 rounded-2xl p-4 border border-gray-100">
          <div className="flex justify-between items-center mb-4">
            <h2 className="font-bold text-gray-900">Egg Style</h2>
            <span className="text-[10px] font-bold text-green-600 bg-green-50 px-2 py-1 rounded flex items-center gap-1">
              <CheckCircle2 className="w-3 h-3" /> Required
            </span>
          </div>
          
          <div className="space-y-1">
            {styles.map((style) => (
              <label 
                key={style}
                className="flex items-center justify-between p-3 rounded-xl cursor-pointer hover:bg-white transition-colors group"
              >
                <span className={`text-sm font-medium ${eggStyle === style ? 'text-gray-900' : 'text-gray-500'}`}>
                  {style}
                </span>
                <div className="relative flex items-center">
                  <input 
                    type="radio" 
                    name="eggStyle"
                    checked={eggStyle === style}
                    onChange={() => setEggStyle(style)}
                    className="sr-only"
                  />
                  <div className={`w-5 h-5 rounded-full border-2 transition-all flex items-center justify-center ${
                    eggStyle === style ? 'border-gray-900' : 'border-gray-300 group-hover:border-gray-400'
                  }`}>
                    {eggStyle === style && <div className="w-2.5 h-2.5 bg-gray-900 rounded-full" />}
                  </div>
                </div>
              </label>
            ))}
          </div>
        </div>
      </div>

      {/* Sticky Bottom Bar */}
      <div className="p-6 bg-white border-t border-gray-100 flex items-center gap-4">
        <div className="flex items-center bg-gray-100 rounded-xl p-1">
          <button 
            onClick={() => setQuantity(Math.max(1, quantity - 1))}
            aria-label="수량 감소"
            className="w-10 h-10 flex items-center justify-center text-gray-500 hover:text-gray-900 transition-colors"
          >
            <Minus className="w-4 h-4" />
          </button>
          <span 
            className="w-8 text-center font-bold text-gray-900"
            aria-live="polite"
            aria-label={`현재 수량 ${quantity}개`}
          >
            {quantity}
          </span>
          <button 
            onClick={() => setQuantity(quantity + 1)}
            aria-label="수량 증가"
            className="w-10 h-10 flex items-center justify-center text-gray-500 hover:text-gray-900 transition-colors"
          >
            <Plus className="w-4 h-4" />
          </button>
        </div>

        <button 
          onClick={onConfirm}
          className="flex-1 bg-yellow-400 hover:bg-yellow-500 text-gray-900 h-12 rounded-xl font-bold flex items-center justify-between px-6 transition-colors shadow-lg shadow-yellow-100"
          aria-label={`결제 및 예약하기. 총 금액 ${(menu.price * quantity).toLocaleString()}원`}
        >
          <span>Add to cart</span>
          <span>₭ {((menu.price * quantity) / 1000).toFixed(2)}</span>
        </button>
      </div>
    </motion.div>
  );
}

// --- Screen 3: Transport & Guidance ---
function Screen3({ 
  restaurant, 
  onSpeak,
  onBack 
}: { 
  restaurant: Restaurant; 
  onSpeak: (t: string) => void;
  onBack: () => void;
  key?: string;
}) {
  const [isGuiding, setIsGuiding] = useState(false);
  const [guideMessage, setGuideMessage] = useState('');

  const startGuidance = () => {
    const msg = TRANSPORT_DATA[0].guideText;
    setGuideMessage(msg);
    setIsGuiding(true);
    onSpeak(msg);
    
    setTimeout(() => {
      setIsGuiding(false);
    }, 4000);
  };

  return (
    <motion.div 
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 1.05 }}
      className="flex flex-col h-full bg-gray-50"
    >
      {/* Header */}
      <div className="p-6 pt-12 bg-white shadow-sm">
        <button 
          onClick={onBack}
          className="mb-4 text-gray-400 hover:text-gray-900 flex items-center gap-1 text-sm font-medium transition-colors"
        >
          <ChevronLeft className="w-4 h-4" /> 뒤로
        </button>
        <h1 className="text-xl font-bold text-gray-900 leading-tight">
          예약 완료!<br />
          <span className="text-yellow-600">{restaurant.name}</span>으로 이동합니다
        </h1>
      </div>

      {/* Transport List */}
      <div className="p-6 flex-1 space-y-4 overflow-y-auto">
        <h2 className="text-xs font-bold text-gray-400 uppercase tracking-wider">추천 교통편</h2>
        
        {TRANSPORT_DATA.map((t) => (
          <div 
            key={t.id}
            className="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 hover:border-yellow-200 transition-colors"
          >
            <div className="flex justify-between items-start mb-3">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-blue-50 rounded-full flex items-center justify-center text-blue-600">
                  <Bus className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-bold text-gray-900">{t.method}</h3>
                  <p className="text-xs text-gray-500">약 {t.time} 소요</p>
                </div>
              </div>
              <span className="text-[10px] font-bold text-blue-600 bg-blue-50 px-2 py-1 rounded">최적 경로</span>
            </div>
            
            <div className="flex items-start gap-2 p-3 bg-gray-50 rounded-xl">
              <Info className="w-4 h-4 text-gray-400 mt-0.5 shrink-0" />
              <p className="text-xs text-gray-600 leading-relaxed">
                <span className="font-bold text-gray-900">사회적 약자 정보:</span><br />
                {t.mobilityOption}
              </p>
            </div>
          </div>
        ))}
      </div>

      {/* Action Button */}
      <div className="p-6 bg-white border-t border-gray-100">
        <button 
          onClick={startGuidance}
          disabled={isGuiding}
          className={`w-full h-14 rounded-2xl font-bold flex items-center justify-center gap-3 transition-all shadow-lg ${
            isGuiding 
            ? 'bg-gray-100 text-gray-400' 
            : 'bg-gray-900 text-white hover:bg-black shadow-gray-200'
          }`}
          aria-label="시각 및 음성 안내 시작"
        >
          <Volume2 className={`w-5 h-5 ${isGuiding ? 'animate-pulse' : ''}`} />
          {isGuiding ? '안내 진행 중...' : '시각/음성 안내 시작'}
        </button>
      </div>

      {/* Guidance Popup */}
      <AnimatePresence>
        {isGuiding && (
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 20 }}
            className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[80%] bg-white p-8 rounded-[2rem] shadow-2xl z-[110] border-4 border-yellow-400 flex flex-col items-center text-center"
          >
            <div className="w-16 h-16 bg-yellow-100 rounded-full flex items-center justify-center mb-4">
              <Volume2 className="w-8 h-8 text-yellow-600 animate-bounce" />
            </div>
            <p className="text-lg font-bold text-gray-900 mb-2">음성 안내 중</p>
            <p className="text-gray-600 text-sm leading-relaxed">
              "{guideMessage}"
            </p>
          </motion.div>
        )}
      </AnimatePresence>
      
      {isGuiding && <div className="absolute inset-0 bg-black/20 backdrop-blur-sm z-[105]" />}
    </motion.div>
  );
}
