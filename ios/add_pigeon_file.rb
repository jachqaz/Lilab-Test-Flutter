require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Buscar el target Runner
target = project.targets.first

# Buscar el grupo Runner
runner_group = project.main_group.find_subpath('Runner', true)

# Verificar si el archivo ya existe
file_ref = runner_group.files.find { |f| f.path == 'NativeApi.g.swift' }

unless file_ref
  # Agregar el archivo al proyecto
  file_ref = runner_group.new_file('NativeApi.g.swift')
  
  # Agregar a la fase de compilación
  target.source_build_phase.add_file_reference(file_ref)
  
  puts "✅ NativeApi.g.swift agregado al proyecto Xcode"
else
  puts "ℹ️  NativeApi.g.swift ya existe en el proyecto"
end

# Guardar cambios
project.save

puts "✅ Proyecto Xcode actualizado"
