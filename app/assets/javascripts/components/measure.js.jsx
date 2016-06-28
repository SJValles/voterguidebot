var Measure = React.createClass({
  mixins: [HandleChange],
  getDefaultProps: function() {
    return { id: false,
             title: '',
             description: '',
             yes_means: '',
             no_means: '',
             endorsements: [] }
  },
  getInitialState: function() {
    return { title: this.props.title,
             description: this.props.description,
             yes_means: this.props.yes_means,
             no_means: this.props.no_means,
             endorsements: this.props.endorsements }
  },
  render: function() {
    return <div className="measure mui-col-md-11 measure--form">
      <div className="mui-row">
          <h3>Details</h3>
          <InputComponent name="title"
                          label="Ballot Measure Title"
                          ref='title'
                          value={ this.state.title }
                          onChange={ this.handleChange } />
          <InputComponent name="description"
                          element="textarea"
                          ref='description'
                          label="Description of Measure"
                          value={ this.state.description }
                          onChange={ this.handleChange } />
      </div>
      <div className="mui-row mui-panel for--block">
        <h4>In Favor</h4>
        <InputComponent name="yes_means"
                        className="mui-col-md-6"
                        label="What happens if it passes?"
                        element="textarea"
                        value={this.state.yes_means}
                        onChange={this.handleChange} />
        <Endorsements ref="yes_endorsements"
                      className="mui-col-md-5"
                      endorsements={this.state.endorsements}
                      handleChange={this.handleChange}
                      endorsed_type='measure'
                      endorsed_id={this.props.id}
                      stance="for" />
      </div>
      <div className="mui-row mui-panel against--block">
        <h4>Against</h4>
        <InputComponent name="no_means"
                        className="mui-col-md-6"
                        label="What happens if it does not pass?"
                        element="textarea"
                        value={this.state.no_means}
                        onChange={this.handleChange} />
        <Endorsements ref="no_endorsements"
                      className="mui-col-md-5"
                      endorsements={this.state.endorsements}
                      handleChange={this.handleChange}
                      endorsed_type='measure'
                      endorsed_id={this.props.id}
                      stance="against" />
      </div>
    </div>
  }
})