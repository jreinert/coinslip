import React from 'react'
import { Grid, Row, Col, Navbar } from 'react-bootstrap'
import { Route, Redirect } from 'react-router-dom'
import { Create, Redeem, Notification } from 'components'
import 'stylesheets/main.scss'

const RootRedirect = () => <Redirect to='/create'/>

const App = () => (
  <Grid>
    <Row>
      <Navbar>
        <Navbar.Header>
          <Navbar.Brand>
            <a href="#/create">Coinslip</a>
          </Navbar.Brand>
        </Navbar.Header>
      </Navbar>
      <Col xs={12}>
        <Notification/>
        <Route path='/create' component={Create}/>
        <Route path='/redeem' component={Redeem}/>
        <Route path='/' exact component={RootRedirect}/>
      </Col>
    </Row>
  </Grid>
)

export default App
