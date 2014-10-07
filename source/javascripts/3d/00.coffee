scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(70 , window.innerWidth / window.innerHeight, 0.1, 1000)

renderer = new THREE.WebGLRenderer()
renderer.setClearColor(0xFFD600, 1);
renderer.setSize(window.innerWidth, window.innerHeight)

$ ->
  $(".container")[0].appendChild(renderer.domElement)

PALETTE = [
   0xFFDB00
   0x1D1900
   0x9A8500
   0xFFED7D
   0xF3EBB7
   0xF1007B
   0x18000C
   0x7F0041
   0xED74B2
   0xC896B0
   0x049FE2
   0x000D12
   0x014461
   0x70BADA
   0x758E99
]

color = ->
  PALETTE[Math.floor(Math.random()*PALETTE.length)]

r = (m=1) ->
  Math.random() * m

class Cube
  constructor: (x, y, z) ->
    size = 0.1 + (r(0.8))
    @size = [size, size, size]
    @position = [x, y, z]
    @color = color()
    @el = createCube(@size, @position, @color)
    @xK = (r(2)-1) / 100
    @yK = (r(2)-1) / 100

  renderFrame: () ->
    @el.rotation.x += @xK
    @el.rotation.y += @yK

createCube = (sizes, position, color) ->
  geometry = new THREE.BoxGeometry(sizes[0], sizes[1], sizes[2])
  material = new THREE.MeshNormalMaterial({
    color: color
    transparent: false
    opacity: 1
  })
  cube = new THREE.Mesh(geometry, material)
  cube.position.x = position[0]
  cube.position.y = position[1]
  cube.position.z = position[2]
  cube


CUBES = []

makeCubes = (number, x, y, z, kx, ky, kz) ->
  while number > 0
    cube = new Cube(x, y, z)
    x += r(kx)*7
    y += r(ky)*7
    z += r(kz)*7
    CUBES.push(cube)
    number -= 1
    scene.add(cube.el)

makeCubes(300, -2, -10,  1, 0.1, 0.2, -0.1)
makeCubes(300, 3, -2, -5, -0.1, 0.1,  0.01)
makeCubes(300, -3, 1.5, -5, 0.1, 0.05,  0.05)
makeCubes(300, -1, 1.5, -5, 0.1, 0.02,  0.05)
makeCubes(300, -1, 1.5, -5, -0.1, 0.02,  0.05)

camera.position.x = -1
camera.position.y = 2.3
camera.position.z = 0.2

render = ->
  for cube in CUBES
    cube.renderFrame()

  renderer.render(scene, camera)

  requestAnimationFrame(render)

$ ->
  render()

