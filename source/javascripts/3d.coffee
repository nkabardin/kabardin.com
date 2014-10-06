
console.log 'hey'
scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(90 , window.innerWidth / window.innerHeight, 0.1, 1000)

renderer = new THREE.WebGLRenderer()
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

PALETTE = [
  0x255C69
  0x83CEE0
  0x829FA6
  0x012730
  0x015568
  0xAA8939
  0xFFDF91
  0xFFEFC7
  0x4E3800
  0xA87800
  0xAA3E39
  0xFF9791
  0xFFC9C7
  0x4E0400
  0xA80800
]

color = ->
  PALETTE[Math.floor(Math.random()*PALETTE.length)]

r = (m=1) ->
  Math.random() * m

class Cube
  constructor: (x, y, z) ->
    size = 0.4 + (r(0.1))
    @size = [size, size, size]
    @position = [x, y, z]
    @color = color()
    @el = createCube(@size, @position, @color)

  renderFrame: () ->
    @el.rotation.x += r(5) / 1000
    @el.rotation.y += r(5) / 1000

createCube = (sizes, position, color) ->
  geometry = new THREE.BoxGeometry(sizes[0], sizes[1], sizes[2])
  material = new THREE.MeshNormalMaterial({
    color: color
    transparent: true
    opacity: 0.3
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
    x += r(kx)
    y += r(ky)
    z += r(kz)
    CUBES.push(cube)
    number -= 1
    scene.add(cube.el)

makeCubes(300, -2, -10,  1, 0.1, 0.2, -0.1)
makeCubes(300, 3, -2, -5, -0.1, 0.1,  0.01)
makeCubes(300, -3, 1.5, -5, 0.1, 0.05,  0.05)
makeCubes(300, -1, 1.5, -5, 0.1, 0.02,  0.05)
makeCubes(300, -1, 1.5, -5, -0.1, 0.02,  0.05)



light = new THREE.PointLight(0xFFFFFF)

light.position.x = 1
light.position.y = 1
light.position.z = 1

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

