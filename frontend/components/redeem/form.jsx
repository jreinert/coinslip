import React from 'react'
import PropTypes from 'prop-types'
import {
  Form as BsForm, FormGroup, ControlLabel, FormControl, Button
} from 'react-bootstrap'

const changeHandler = (actionCreator, attribute) => ({ target: { value } }) =>
  actionCreator({ [attribute]: value })

const submitHandler = (actionCreator, attributes) => (event) => {
  event.preventDefault()
  actionCreator(attributes)
}

const Form = ({ onChange, onSubmit, request }) => {
  const { address } = request
  return (
    <BsForm>
      <FormGroup>
        <ControlLabel>Payment address</ControlLabel>
        <FormControl
          type="text"
          value={address || ''}
          onChange={changeHandler(onChange, 'address')}
        />
      </FormGroup>
      <FormGroup>
        <Button type="submit" onClick={submitHandler(onSubmit, request)}>
          Redeem
        </Button>
      </FormGroup>
    </BsForm>
  )
}

Form.propTypes = {
  onChange: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  request: PropTypes.shape({
    address: PropTypes.string
  }).isRequired
}

export default Form
