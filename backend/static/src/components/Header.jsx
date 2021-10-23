import React, {Component} from "react";
import {
    withRouter
} from 'react-router-dom'

class Header extends Component {
    goHome = () => {
        this.props.history.push('/');
    };

    render() {
        return (
            <div>

                <div id={"header"}>
                    <i className="fa fa-home leftHomeIcon" aria-hidden="true" onClick={this.goHome}/>
                    Apexio
                </div>
            </div>
        );
    }
}

export default withRouter(Header);