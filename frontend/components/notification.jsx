import React from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { Row, Alert } from 'react-bootstrap'
import PropTypes from 'prop-types'
import actions from 'actions'

const { ui: { notification: { dismiss } } } = actions

const Notification = ({ onDismiss, message, severity }) => (
  <Row>
    { message ? <Alert bsStyle={severity} onDismiss={onDismiss}>{message}</Alert> : null }
  </Row>
)

Notification.propTypes = {
  onDismiss: PropTypes.func.isRequired,
  message: PropTypes.string,
  severity: PropTypes.string
}

const mapStateToProps = ({ ui: { notification } }) => notification
const mapDispatchToProps = dispatch => bindActionCreators({
  onDismiss: dismiss
}, dispatch)

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Notification)
