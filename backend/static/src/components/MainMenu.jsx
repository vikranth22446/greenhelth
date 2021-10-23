import React, {Component} from 'react';
import Header from "./Header";
import {
    withRouter
} from 'react-router-dom'

class MainMenu extends Component {
    onRuleForwarding = () => {
        this.props.history.push('/rules');
    };

    render() {
        return (
            <div>
                <Header/>
                <div key="loading" id={"mainLogoLoading"} className={"animated animatedFadeInUp fadeInUp"}>
                    <img src={"/static/logo.png"} alt={""}/> <br/>
                    <em>Declutter your life</em>
                </div>
                <div className={"mainHorizontalButtons"}>
                    <div className={"third"}>
                        <img src={"/static/clustering.png"} className={"menuMainIcon"}/>
                        <br/>
                        <button className={"mainButtonStyle"}>
                            Clustering&nbsp;&nbsp;
                            <i className="fa fa-arrow-right rightArrow"/>
                        </button>
                        <p className={"mainIconText"}>
                            Clustering the files in your folder based on information just as
                            file extension, timestamps
                            and content, simplifying large download folders and other messes. </p>
                    </div>

                    <div className={"third"}>
                        <img src={"/static/rule_forwarding.svg"} className={"menuMainIcon"}/>
                        <br/>
                        <button className={"mainButtonStyle"} onClick={this.onRuleForwarding}>
                            Rule Forwarding&nbsp;&nbsp;
                            <i className="fa fa-arrow-right rightArrow"/>
                        </button>
                        <p className={"mainIconText"}>You can forward your files and organize them using many custom
                            rules.
                            Similar to the way you can control your inbox and automate your life.</p>
                    </div>

                    <div className={"third"}>
                        <img src={"/static/tag_label.svg"} className={"menuMainIcon"}/>
                        <br/>
                        <button className={"mainButtonStyle"}>
                            Tag Label&nbsp;&nbsp;
                            <i className="fa fa-arrow-right rightArrow"/>
                        </button>
                        <p className={"mainIconText"}>We used supervised learning to understand how to organize and
                            label
                            different files in your system. </p>
                    </div>
                </div>
            </div>
        );
    }
}

export default withRouter(MainMenu);