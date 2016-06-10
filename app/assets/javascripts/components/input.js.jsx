var InputComponent = React.createClass({
  getDefaultProps: function() {
    return {
      element: 'input',
      type: 'text',
      value: null,
      placeholder: null,
      fa: null,
      onChange: function() { }
    }
  },
  handleChange: function(event) {
    this.props.handleChange(event)
  },
  render: function() {
    var label = this.props.label ? <label>{ this.props.label }</label> : '',
        input = <this.props.element ref="input"
                                    { ...this.props }
                                    value={ this.props.value } />,
        font_awesome = ''

    if( this.props.fa !== null ) {
      font_awesome = <i className={'fa fa-'+this.props.fa} />
    }
    if( this.props.element === 'ImageComponent' ) {
        input = <ImageComponent ref="input"
                                { ...this.props }
                                value={ this.props.value } />
    }

    return <div className={'mui-textfield ' + (this.props.fa ? 'fa-prefix' : '')}>
      { label }
      { this.props.afterLabel }
      { font_awesome }
      { input }
      { this.props.after }
    </div>
  }
})
