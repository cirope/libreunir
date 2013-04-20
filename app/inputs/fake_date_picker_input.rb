class FakeDatePickerInput < SimpleForm::Inputs::Base
  def input
    template.text_field_tag(
      attribute_name,
      (I18n.l(object.send(attribute_name)) if object.send(attribute_name)),
      input_html_options.reverse_merge(
        autocomplete: 'off',
        data: { 'date-picker' => true }
      )
    ).html_safe
  end
end
