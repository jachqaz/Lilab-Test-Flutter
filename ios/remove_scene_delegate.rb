require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Buscar y remover SceneDelegate.swift
target.source_build_phase.files.each do |file|
  if file.file_ref && file.file_ref.path == 'SceneDelegate.swift'
    puts "Removiendo SceneDelegate.swift del proyecto..."
    file.remove_from_project
  end
end

# Remover referencia del grupo
project.main_group.recursive_children.each do |item|
  if item.is_a?(Xcodeproj::Project::Object::PBXFileReference) && item.path == 'SceneDelegate.swift'
    puts "Removiendo referencia de SceneDelegate.swift..."
    item.remove_from_project
  end
end

project.save
puts "✅ SceneDelegate.swift removido del proyecto Xcode"
