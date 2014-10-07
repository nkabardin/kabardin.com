scene = new T3.Scene()
camera = new T3.PerspectiveCamera(90, window.innerWidth / window.innerHeight, 0.1, 1000)

renderer = new T3.WebGLRenderer()
renderer.setClearColor(0x265B6A, 1);
renderer.setSize(window.innerWidth, window.innerHeight)

r = (m=1) ->
  Math.random() * m

PALETTE = [
  0xAA8139
  0xA67B31
  0xB28C4B
  0xAE8642

]

color = ->
  PALETTE[Math.floor(Math.random()*PALETTE.length)]

class Cube
  constructor: (x, y, z) ->
    size = 0.05
    @size = [size, size, size]
    @position = [x, y, z]
    @color = color()
    @el = createCube(@size, @position, @color)
    @xK = (r(2)-1) / 1000
    @yK = (r(2)-1) / 1000

  renderFrame: () ->
    @el.position.z = 0.5 + (Math.sin(frameIndex/1000) + r(0.01))
    @el.rotation.x = frameIndex/500
    @el.rotation.x = @xK
    @el.rotation.y = @yK

createCube = (sizes, position, color) ->
  geometry = new T3.BoxGeometry(sizes[0], sizes[1], sizes[2])
  material = new T3.MeshBasicMaterial({
    color: color
  })
  cube = new T3.Mesh(geometry, material)
  cube.position.x = position[0]
  cube.position.y = position[1]
  cube.position.z = position[2]
  cube

CUBES = []

makeCube = (x, y, z) ->
  cube = new Cube(x, y, z)
  scene.add(cube.el)
  CUBES.push(cube)


drawCubicCircle = (radius, elements) ->
  angle = 0
  x = 0
  while angle < ((Math.PI / 2) + ((Math.PI / 2) / (elements)))

    x = Math.sin(angle) * radius
    y = Math.cos(angle) * radius

    makeCube(x, y, 0)
    makeCube(-x, y, 0)
    makeCube(x, -y, 0)
    makeCube(-x, -y, 0)
    angle += ((Math.PI / 2) / (elements))

els = 30
radius = 0.3
while radius >= 0 and els > 0
  drawCubicCircle(radius, els)
  radius -= 0.03
  els -= 1




window.camera = camera


camera.position.x = 0
camera.position.y = 0
camera.position.z = 2

#camera.lookAt(new T3.Vector3(0, 0, 0))

frameIndex = 0

render = ->
  frameIndex += 1

  for cube in CUBES
    cube.renderFrame()

  renderer.render(scene, camera)

  requestAnimationFrame(render)

$ ->
  $('audio').on('canplaythrough', ->
    console.log 'canplay'
    $(".loading").remove()
    $(".container")[0].appendChild(renderer.domElement)
  )


  render()

drone = new Audio('/audio/moon_loop.ogg')
drone.addEventListener('ended', (->
    @currentTime = 0
    @play()
), false)
drone.play()

$(window).resize ->
  renderer.setSize(window.innerWidth, window.innerHeight)

