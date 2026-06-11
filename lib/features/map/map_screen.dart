import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

/// 交互式地图页面 - 展示景点、活动和事件
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  
  // 地图标记集合
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  
  // 当前位置
  Position? _currentPosition;
  
  // 地图类型
  MapType _mapType = MapType.normal;
  
  // 是否显示交通
  bool _trafficEnabled = false;
  
  // 是否显示我的位置
  bool _myLocationEnabled = true;
  
  // 选中的标记ID
  MarkerId? _selectedMarkerId;
  
  // 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  
  // 筛选类型
  String _selectedFilter = 'all'; // all, places, activities, events
  
  // 示例数据 - 埃及旅游景点
  final List<MapLocation> _locations = [
    // 景点
    MapLocation(
      id: 'pyramids',
      name: '吉萨金字塔',
      nameEn: 'Giza Pyramids',
      lat: 29.9792,
      lng: 31.1342,
      type: LocationType.place,
      category: '历史遗迹',
      rating: 4.9,
      imageUrl: 'https://example.com/pyramids.jpg',
      description: '世界七大奇迹之一，古埃及文明的象征',
    ),
    MapLocation(
      id: 'sphinx',
      name: '狮身人面像',
      nameEn: 'Great Sphinx',
      lat: 29.9753,
      lng: 31.1376,
      type: LocationType.place,
      category: '历史遗迹',
      rating: 4.8,
      imageUrl: 'https://example.com/sphinx.jpg',
      description: '守护金字塔的神秘雕像',
    ),
    MapLocation(
      id: 'luxor_temple',
      name: '卢克索神庙',
      nameEn: 'Luxor Temple',
      lat: 25.6995,
      lng: 32.6391,
      type: LocationType.place,
      category: '历史遗迹',
      rating: 4.7,
      imageUrl: 'https://example.com/luxor.jpg',
      description: '古埃及宗教建筑的杰作',
    ),
    MapLocation(
      id: 'karnak',
      name: '卡尔纳克神庙',
      nameEn: 'Karnak Temple',
      lat: 25.7188,
      lng: 32.6573,
      type: LocationType.place,
      category: '历史遗迹',
      rating: 4.8,
      imageUrl: 'https://example.com/karnak.jpg',
      description: '世界上最大的古代宗教建筑群',
    ),
    MapLocation(
      id: 'abu_simbel',
      name: '阿布辛贝神庙',
      nameEn: 'Abu Simbel',
      lat: 22.3372,
      lng: 31.6258,
      type: LocationType.place,
      category: '历史遗迹',
      rating: 4.9,
      imageUrl: 'https://example.com/abusimbel.jpg',
      description: '拉美西斯二世的宏伟神庙',
    ),
    MapLocation(
      id: 'valley_kings',
      name: '帝王谷',
      nameEn: 'Valley of the Kings',
      lat: 25.7402,
      lng: 32.6014,
      type: LocationType.place,
      category: '历史遗迹',
      rating: 4.7,
      imageUrl: 'https://example.com/valley.jpg',
      description: '法老们的安息之地',
    ),
    MapLocation(
      id: 'cairo_museum',
      name: '埃及博物馆',
      nameEn: 'Egyptian Museum',
      lat: 30.0478,
      lng: 31.2336,
      type: LocationType.place,
      category: '博物馆',
      rating: 4.6,
      imageUrl: 'https://example.com/museum.jpg',
      description: '收藏世界上最丰富的古埃及文物',
    ),
    MapLocation(
      id: 'citadel',
      name: '萨拉丁城堡',
      nameEn: 'Saladin Citadel',
      lat: 30.0287,
      lng: 31.2599,
      type: LocationType.place,
      category: '历史遗迹',
      rating: 4.5,
      imageUrl: 'https://example.com/citadel.jpg',
      description: '开罗的地标性城堡',
    ),
    // 活动
    MapLocation(
      id: 'nile_cruise',
      name: '尼罗河游轮',
      nameEn: 'Nile Cruise',
      lat: 25.6872,
      lng: 32.6396,
      type: LocationType.activity,
      category: '游船',
      rating: 4.8,
      imageUrl: 'https://example.com/nile.jpg',
      description: '在尼罗河上享受浪漫晚餐',
    ),
    MapLocation(
      id: 'hot_air_balloon',
      name: '热气球之旅',
      nameEn: 'Hot Air Balloon',
      lat: 25.7200,
      lng: 32.6500,
      type: LocationType.activity,
      category: '冒险',
      rating: 4.9,
      imageUrl: 'https://example.com/balloon.jpg',
      description: '俯瞰卢克索的壮丽景色',
    ),
    MapLocation(
      id: 'desert_safari',
      name: '沙漠探险',
      nameEn: 'Desert Safari',
      lat: 29.9800,
      lng: 31.1300,
      type: LocationType.activity,
      category: '冒险',
      rating: 4.7,
      imageUrl: 'https://example.com/safari.jpg',
      description: '体验撒哈拉沙漠的刺激',
    ),
    MapLocation(
      id: 'snorkeling',
      name: '红海浮潜',
      nameEn: 'Red Sea Snorkeling',
      lat: 27.2579,
      lng: 33.8116,
      type: LocationType.activity,
      category: '水上运动',
      rating: 4.8,
      imageUrl: 'https://example.com/redsea.jpg',
      description: '探索红海的绚丽海底世界',
    ),
    // 事件
    MapLocation(
      id: 'sound_light_show',
      name: '声光秀',
      nameEn: 'Sound and Light Show',
      lat: 29.9785,
      lng: 31.1345,
      type: LocationType.event,
      category: '表演',
      rating: 4.6,
      imageUrl: 'https://example.com/show.jpg',
      description: '金字塔前的震撼灯光表演',
    ),
    MapLocation(
      id: 'festival',
      name: '尼罗河节',
      nameEn: 'Nile Festival',
      lat: 30.0444,
      lng: 31.2357,
      type: LocationType.event,
      category: '节日',
      rating: 4.7,
      imageUrl: 'https://example.com/festival.jpg',
      description: '庆祝尼罗河的年度盛典',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadMarkers();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// 检查位置权限
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    }
  }

  /// 获取当前位置
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      
      // 移动相机到当前位置
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  /// 加载标记
  void _loadMarkers() {
    final filteredLocations = _getFilteredLocations();
    
    setState(() {
      _markers.clear();
      
      for (var location in filteredLocations) {
        final marker = Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.lat, location.lng),
          icon: _getMarkerIcon(location.type),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: '${location.category} • ⭐ ${location.rating}',
            onTap: () => _showLocationDetails(location),
          ),
          onTap: () {
            setState(() {
              _selectedMarkerId = MarkerId(location.id);
            });
          },
        );
        
        _markers.add(marker);
      }
    });
  }

  /// 根据筛选条件获取位置列表
  List<MapLocation> _getFilteredLocations() {
    if (_selectedFilter == 'all') {
      return _locations;
    }
    return _locations.where((loc) {
      switch (_selectedFilter) {
        case 'places':
          return loc.type == LocationType.place;
        case 'activities':
          return loc.type == LocationType.activity;
        case 'events':
          return loc.type == LocationType.event;
        default:
          return true;
      }
    }).toList();
  }

  /// 获取标记图标
  BitmapDescriptor _getMarkerIcon(LocationType type) {
    switch (type) {
      case LocationType.place:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case LocationType.activity:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case LocationType.event:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
  }

  /// 显示位置详情
  void _showLocationDetails(MapLocation location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationDetailSheet(location: location),
    );
  }

  /// 移动到指定位置
  void _moveToLocation(LatLng target, {double zoom = 15}) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }

  /// 切换地图类型
  void _cycleMapType() {
    setState(() {
      final types = MapType.values;
      final currentIndex = types.indexOf(_mapType);
      _mapType = types[(currentIndex + 1) % types.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 地图
          GoogleMap(
            mapType: _mapType,
            initialCameraPosition: const CameraPosition(
              target: LatLng(26.8206, 30.8025), // 埃及中心位置
              zoom: 6,
            ),
            markers: _markers,
            circles: _circles,
            myLocationEnabled: _myLocationEnabled,
            myLocationButtonEnabled: false,
            trafficEnabled: _trafficEnabled,
            compassEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              _setMapStyle();
            },
            onTap: (_) {
              setState(() {
                _selectedMarkerId = null;
              });
            },
          ),
          
          // 搜索栏
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: _buildSearchBar(),
          ),
          
          // 筛选器
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 16,
            child: _buildFilterChips(),
          ),
          
          // 图例
          Positioned(
            top: MediaQuery.of(context).padding.top + 140,
            right: 16,
            child: _buildLegend(),
          ),
          
          // 控制按钮
          Positioned(
            bottom: 100,
            right: 16,
            child: _buildControlButtons(),
          ),
          
          // 底部位置列表
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  /// 搜索栏
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索景点、活动或事件...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  /// 筛选芯片
  Widget _buildFilterChips() {
    final filters = [
      {'key': 'all', 'label': '全部', 'icon': Icons.map},
      {'key': 'places', 'label': '景点', 'icon': Icons.place},
      {'key': 'activities', 'label': '活动', 'icon': Icons.local_activity},
      {'key': 'events', 'label': '事件', 'icon': Icons.event},
    ];

    return Container(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['key'];
          
          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            backgroundColor: Colors.white,
            selectedColor: Theme.of(context).primaryColor,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  filter['icon'] as IconData,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  filter['label'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter['key'] as String;
                _loadMarkers();
              });
            },
          );
        },
      ),
    );
  }

  /// 图例
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLegendItem(Colors.red, '景点'),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.green, '活动'),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.purple, '事件'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  /// 控制按钮
  Widget _buildControlButtons() {
    return Column(
      children: [
        // 地图类型切换
        FloatingActionButton.small(
          heroTag: 'mapType',
          backgroundColor: Colors.white,
          onPressed: _cycleMapType,
          child: Icon(
            _mapType == MapType.normal
                ? Icons.satellite
                : _mapType == MapType.satellite
                    ? Icons.terrain
                    : Icons.map,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        // 交通图层
        FloatingActionButton.small(
          heroTag: 'traffic',
          backgroundColor: _trafficEnabled ? Colors.blue : Colors.white,
          onPressed: () {
            setState(() {
              _trafficEnabled = !_trafficEnabled;
            });
          },
          child: Icon(
            Icons.traffic,
            color: _trafficEnabled ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        // 定位按钮
        FloatingActionButton(
          heroTag: 'location',
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: _getCurrentLocation,
          child: const Icon(Icons.my_location, color: Colors.white),
        ),
      ],
    );
  }

  /// 底部列表
  Widget _buildBottomSheet() {
    final filteredLocations = _getFilteredLocations();
    
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 拖动指示器
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '附近 ${_getFilterLabel()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${filteredLocations.length} 个结果',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 横向列表
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return LocationCard(
                  location: location,
                  onTap: () {
                    _moveToLocation(
                      LatLng(location.lat, location.lng),
                      zoom: 16,
                    );
                    _showLocationDetails(location);
                  },
                );
              },
            ),
          ),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _getFilterLabel() {
    switch (_selectedFilter) {
      case 'places':
        return '景点';
      case 'activities':
        return '活动';
      case 'events':
        return '事件';
      default:
        return '地点';
    }
  }

  /// 设置地图样式
  Future<void> _setMapStyle() async {
    // 可以在这里加载自定义地图样式 JSON
    // String style = await rootBundle.loadString('assets/map_style.json');
    // _mapController?.setMapStyle(style);
  }
}

/// 位置数据模型
class MapLocation {
  final String id;
  final String name;
  final String nameEn;
  final double lat;
  final double lng;
  final LocationType type;
  final String category;
  final double rating;
  final String imageUrl;
  final String description;

  MapLocation({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.lat,
    required this.lng,
    required this.type,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });
}

enum LocationType { place, activity, event }

/// 位置卡片
class LocationCard extends StatelessWidget {
  final MapLocation location;
  final VoidCallback onTap;

  const LocationCard({
    Key? key,
    required this.location,
    required this.onTap,
  }) : super(key: key);

  Color _getTypeColor() {
    switch (location.type) {
      case LocationType.place:
        return Colors.red;
      case LocationType.activity:
        return Colors.green;
      case LocationType.event:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon() {
    switch (location.type) {
      case LocationType.place:
        return Icons.place;
      case LocationType.activity:
        return Icons.local_activity;
      case LocationType.event:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 80,
                color: Colors.grey[300],
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 占位图
                    Icon(
                      _getTypeIcon(),
                      size: 40,
                      color: Colors.grey[400],
                    ),
                    
                    // 类型标签
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTypeColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          location.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    // 评分
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              location.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 信息区域
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location.nameEn,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 位置详情底部弹窗
class LocationDetailSheet extends StatelessWidget {
  final MapLocation location;

  const LocationDetailSheet({Key? key, required this.location}) : super(key: key);

  Color _getTypeColor() {
    switch (location.type) {
      case LocationType.place:
        return Colors.red;
      case LocationType.activity:
        return Colors.green;
      case LocationType.event:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 拖动指示器
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 图片
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          location.type == LocationType.place
                              ? Icons.place
                              : location.type == LocationType.activity
                                  ? Icons.local_activity
                                  : Icons.event,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 类型标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      location.category,
                      style: TextStyle(
                        color: _getTypeColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 名称
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // 英文名
                  Text(
                    location.nameEn,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 评分
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        location.rating.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(2,847 评价)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 描述
                  Text(
                    '简介',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    location.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 坐标信息
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '坐标',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // 添加到行程
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('已将 ${location.name} 添加到行程')),
                            );
                          },
                          icon: const Icon(Icons.add_location),
                          label: const Text('添加到行程'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // 添加到收藏
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('已将 ${location.name} 添加到收藏')),
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('收藏'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 导航按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // 打开导航
                        Navigator.pop(context);
                        // 这里可以集成 Google Maps 导航
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('开始导航'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
