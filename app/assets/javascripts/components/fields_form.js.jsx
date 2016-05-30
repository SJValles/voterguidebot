var FieldsForm = React.createClass({
  mixins: [GuideForm],
  getDefaultProps: function() {
    return { fields: [] }
  },
  handleSubmit: function(event) {
    var fields_request = {}

    for (var i = 0; i < this.props.fields.length; i++) {
      var name = this.props.fields[i].name,
          elem = this.refs[name]

      if( !elem.isValid() ) return this.handleError('not all fields are valid')

      fields_request[name] =  elem.state.value
    }

    this.updateGuide(this.props.url, { fields: fields_request })
    event.preventDefault()
  },
  render: function() {
    var fields = _.map(this.props.fields, function(field) {
      return <FieldFormRow ref={field.name}
                           key={field.name+'_form_row'}
                           {...field} />
    })
    return <form ref="form_wrapper" onSubmit={this.handleSubmit}>
            { fields }
            { this.menuComponent() }
          </form>
  }
})
