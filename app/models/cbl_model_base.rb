class CBLModelBase < CBLModel

  def self.attribute *names
    names.each do |name|
      name = name.to_sym
      define_method(name) { getValueOfProperty name }
      define_method(:"#{name}=") { |value| setValue value, ofProperty: name }
    end
  end

  def to_s
    "#{self.class}[#{document.abbreviatedID}]"
  end

end
