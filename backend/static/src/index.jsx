import React from 'react';
import {render} from 'react-dom';
import Landing from './components/Landing';
import {HashRouter, Route, Switch} from 'react-router-dom';
import MainMenu from "./components/MainMenu";
import Rules from './components/Rules'
// const BrowserHistory = require('react-router/lib/BrowserHistory').default;

const NotFound = <div> 404</div>;

function App() {
    return (
        <HashRouter>
            <Switch>
                <Route path="/" component={Landing} exact/>
                <Route path="/main_menu" component={MainMenu} exact/>
                <Route path="/rules" component={Rules} exact/>

                <Route component={NotFound}/>
            </Switch>
        </HashRouter>
    );
}

render(<App/>, document.getElementById('root'));