require 'colorize'
require 'matrix'

# implementation from https://docs.aspose.com/svg/net/drawing-basics/transformation-matrix/

=begin
def calcMatProd(arr1, arr2)
  puts "dimensions match " if arr1[0].length == arr2.length
  ret_val = []
  row = []
  arr1.each_with_index do |row_arr1, r1|
    row = []
    row_arr1.each_with_index do |el, c1|
      puts "multiplying arr1[#{r1}][#{c1}] = #{el} with #{arr2[c1][r1]}"
      row.append(el * arr2[c1][r1])
    end
    ret_val.append(row.inject(&:+))
  end
  ret_val
end

def makeSvgMat(arr)
  [arr[0][0], arr[1][0], arr[0][1], arr[1][1], arr[0][2],arr[1][2] ]
end

def makeMat(arr)
  ret_val = []
  ret_val = [ [arr[0], arr[2], arr[4] ], [arr[1], arr[3], arr[5]] ]
end

def addAnglesToCoords(arr, angle)
  alpha = (angle / 180.0) * Math::PI
  arr[0][0] *= Math.cos(alpha)
  arr[0][1] *= -Math.sin(alpha)
  arr[1][0] *= Math.sin(alpha)
  arr[1][1] *= Math.cos(alpha)
  return arr
end

inpt = [1.3207986,0,0,1.4778892,34.581741,6.0482992]
inpt44 = [1.2492842,0,0,1.2634376,39.670589,15.2824]
init_transform = makeMat(inpt)

puts "What we get from svg #{inpt}".colorize(:green)
puts "What we get make     #{init_transform}".colorize(:green)
puts "checking inverse fcn #{makeSvgMat(init_transform)}".colorize(:green)
identity = [[1.0,0], [0,1.0], [1.0,1.0]]
theta = (45.0/180) * Math::PI
# angles = [[Math.cos(theta), -Math.sin(theta)],[Math.sin(theta), Math.cos(theta)],[1.0, 1.0 ]]
# t_mat = [[Math.cos(theta), -Math.sin(theta)],[Math.sin(theta), Math.cos(theta)],[Math.cos(theta),Math.sin(theta)]]
# pp identity
# pp angles
# p calcMatProd(init_transform, identity)
# our_transform =  calcMatProd(init_transform, angles)
# our_transform = addAnglesToCoords(init_transform, 45)
# puts "our transform the needs to be tranlated to svg mat: #{our_transform}".colorize(:magenta)
# p makeSvgMat(our_transform)

# rotation_mat = [Math.cos(theta), Math.sin(theta), -Math.sin(theta), Math.cos(theta), 0 ,0]
# puts "the rotation matrix in svg: #{rotation_mat}".colorize(:red)

x = 74.714058
y = 77.962494
#shady
puts "transform (#{x},#{y}) to #{calcMatProd(init_transform, [[x, x], [y, y],[1,1]])}"

=end
#new beginning

x = 74.714058
y = 77.962494
font_size = 6.16545
inline_size = 31.2424
inpt = [1.3207986,0,0,1.4778892,34.581741,6.0482992] #as given in svg

def makeMat(arr)
  ret_val =  Matrix[[arr[0], arr[2], arr[4] ], [arr[1], arr[3], arr[5]], [0,0,1]]
end

def makeSvgMat(arr)
  [arr[0][0], arr[1][0], arr[0][1], arr[1][1], arr[0][2],arr[1][2] ]
end
#-----------------------------------------------------------------------------------
#1. convert given svg matrix(...) into proper transformation matrix
#-----------------------------------------------------------------------------------
proper_form = makeMat(inpt)    
pos = Matrix.column_vector([x, y, 1])
transform = proper_form * pos
theta = (-3.0/180)*Math::PI
ctheta = Math.cos(theta)
stheta = Math.sin(theta)
ttheta = Math.tan(theta)
# rotation = Matrix[[ctheta, stheta, 133.2639642067188], [stheta, ctheta, 121.2682270876648], [0,0,1]]
# rot_trans =  proper_form * pos * rotation
puts "nb: input=> #{inpt}"
puts "nb: matrix=> ".colorize(:green)
proper_form.to_a.each {|row| p row }
puts "nb: transform=>#{pos} to #{transform}"
#-----------------------------------------------------------------------------------
#2. compute the rotational transformation matrix in svg format (from the link)
#-----------------------------------------------------------------------------------
x1 = x + font_size
y1 = y + inline_size/2
x2 = 0
y2 = 0
x_dash = (x1 * (1-ctheta)) + (y1 * stheta)
y_dash = (y1 * (1-ctheta)) - (x1 * stheta)
rotation_transform = [ctheta, stheta, -stheta, ctheta, x_dash, y_dash ] #as required by svg
rot_proper = makeMat(rotation_transform)
skew_x_transform = [1,0,ttheta,1,0,0]
skew_y_transform = [1,ttheta,0,1,0,0]
puts "nb: rotation=>".colorize(:green)
rot_proper.to_a.each {|row| p row} 
#-----------------------------------------------------------------------------------
#3. add roational transformation to original svg transformation matrix
#-----------------------------------------------------------------------------------
combined_transform = proper_form * rot_proper
puts "nb: combined transform=>".colorize(:green)
combined_transform.to_a.each {|row| p row}
#-----------------------------------------------------------------------------------
#4. convert 3x3 transformation matrix into svg matrix(...) format
#-----------------------------------------------------------------------------------
puts "nb: combined transform in svg format => #{makeSvgMat(combined_transform.to_a)}".colorize(:yellow)
# puts "nb: skew x=>#{skew_x_transform}"
# puts "nb: skew y=>#{skew_y_transform}"
#tspan2
# 372.951 
# 399.453