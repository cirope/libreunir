class FakeInput < SimpleForm::Inputs::StringInput
  def input
    template.text_field_tag(
      attribute_name,
      object.send(attribute_name),
      input_html_options
    ).html_safe
  end
end
