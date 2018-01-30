import React from 'react'
import { Modal as BsModal, Button, ButtonGroup } from 'react-bootstrap'
import { QRCode } from 'react-qr-svg'
import PropTypes from 'prop-types'
import 'stylesheets/qrcode.scss'

const Modal = ({ onHide, show, redeemURL, amount, currency }) => (
  <BsModal show={show} id="print-section" onHide={onHide}>
    <BsModal.Header>
      <BsModal.Title>
        Coinslip
      </BsModal.Title>
    </BsModal.Header>
    <BsModal.Body>
      {redeemURL ? <QRCode className="qrcode" value={redeemURL}/> : null}
      <table className="table">
        <tbody>
          <tr>
            <th>Amount</th>
            <td>{amount}</td>
          </tr>
          <tr>
            <th>Currency</th>
            <td>{currency}</td>
          </tr>
        </tbody>
      </table>
    </BsModal.Body>
    <BsModal.Footer className="exclude-from-print">
      <ButtonGroup>
        <Button href={redeemURL}>
          Redeem
        </Button>
        <Button onClick={window.print}>
          Print
        </Button>
      </ButtonGroup>
    </BsModal.Footer>
  </BsModal>
)

Modal.propTypes = {
  onHide: PropTypes.func.isRequired,
  show: PropTypes.bool.isRequired,
  redeemURL: PropTypes.string,
  amount: PropTypes.number,
  currency: PropTypes.string
}

export default Modal
