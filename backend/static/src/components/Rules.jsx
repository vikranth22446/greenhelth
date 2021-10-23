import React, {Component} from 'react';
import Header from "./Header";

import {makeStyles} from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import Popup from "reactjs-popup";
import {Checkbox, TextField, Button} from '@material-ui/core';


const useStyles = makeStyles({
    table: {
        marginLeft: '10px',
        marginRight: '10px',
        border: '5px solid transparent'
    },
});


function createData(name, calories, fat, carbs, protein) {
    return {name, calories, fat, carbs, protein};
}

const rows = [
    createData('Frozen yoghurt', 159, 6.0, 24, 4.0),
    createData('Ice cream sandwich', 237, 9.0, 37, 4.3),
    createData('Eclair', 262, 16.0, 24, 6.0),
    createData('Cupcake', 305, 3.7, 67, 4.3),
    createData('Gingerbread', 356, 16.0, 49, 3.9),
];

function onDelete(props, id) {
    fetch('http://127.0.0.1:4242/delete_rule', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({id: id})
    });
    props.reloadData();
}

function DenseTable(props) {
    const classes = useStyles();
    return (
        <TableContainer component={Paper}>
            <Table className={classes.table} size="small" aria-label="a dense table">
                <TableHead>
                    <TableRow>
                        <TableCell>Has</TableCell>
                        <TableCell>Equals</TableCell>
                        <TableCell>Begins With</TableCell>
                        <TableCell>Extension</TableCell>
                        <TableCell>Regex</TableCell>
                        <TableCell>Move to</TableCell>
                        <TableCell>Delete Row</TableCell>
                    </TableRow>
                </TableHead>
                <TableBody>
                    {props.rows.map(row => (
                        <TableRow key={row.id}>
                            <TableCell>{row.has}</TableCell>
                            <TableCell>{row.equals}</TableCell>
                            <TableCell> {row.begins_with}</TableCell>
                            <TableCell>{row.extension}</TableCell>
                            <TableCell>{row.regex}</TableCell>
                            <TableCell>{row.move_to}</TableCell>
                            <TableCell><Button onClick={() => onDelete(props, row.id)}>Delete</Button></TableCell>

                        </TableRow>
                    ))}
                </TableBody>
            </Table>
        </TableContainer>
    );
}

class CreateNewDataForm extends Component {
    constructor(props) {
        super(props);
        this.state = {};
    }

    handleHas = (event) => {
        this.setState({has: event.target.value});
    }

    handleEquals = (event) => {
        this.setState({equals: event.target.value});
    }
    handleBeginsWith = (event) => {
        this.setState({begins_with: event.target.value})
    }

    handleSubmit = (event) => {
        //Make a network call somewhere
        fetch('http://127.0.0.1:4242/create_rule', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(this.state)
        });
        this.props.reloadData();
        this.props.closeModal();
    };

    handleExtension = (event) => {
        this.setState({extension: event.target.value})
    };

    handleDeleteValue = (event) => {
        this.setState({delete_file: event.target.value});
    };
    handleRegex = (event) => {
        this.setState({regex: event.target.value});
    };

    handleDirChange = (event) => {
        this.setState({move_to: event.target.value})
    }

    render() {

        return <div className={"createNewDataForm"}>
            <form onSubmit={this.handleSubmit}>
                Filter the following details: <br/>
                Leave fields that are unneeded empty
                <br/>
                <TextField name={"has"} label="HAS:" onChange={this.handleHas}/>
                <br/>
                <TextField name={"equals"} label="Equals: " onChange={this.handleEquals}/>
                <br/>
                <TextField name={"begins_with"} label="Begins With: "
                           onChange={this.handleBeginsWith}/>
                <br/>
                <TextField name={"regex"} label="Regex: "
                           onChange={this.handleRegex}/>
                <br/>
                <TextField name={"extension"} label="Extension" onChange={this.handleExtension}/>
                <br/>
                Delete File: <Checkbox name={"delete_file"} onChange={this.handleDeleteValue}/>
                <br/>
                Move File To Dir: <input directory="" webkitdirectory="" type="file" name={"move_to"}
                                         onChange={this.handleDirChange}/>

                <Button onClick={this.handleSubmit}> Create New Filter </Button>
            </form>
        </div>
    }
}

const PopupExample = ({reloadData}) => (
    <Popup trigger={
        <Button style={{color: 'white'}} variant="contained" color="primary">Crew New Filter</Button>
    } modal
           closeOnDocumentClick
    >{close => (

        <div id={"dataForm"}>
            <CreateNewDataForm reloadData={() => reloadData()} closeModal={() => close()}/>
        </div>)}
    </Popup>
);

class Rules extends Component {
    constructor(props) {
        super(props);

        this.state = {
            rows: []
        }
    }

    reloadData() {

        fetch('http://127.0.0.1:4242/get_all_rules').then(response => response.json())
            .then((jsonData) => {
                // jsonData is parsed json object received from url
                // console.log(jsonData);
                this.setState({rows: jsonData['rules']})
            })
            .catch((error) => {
                // handle your errors here
                console.error(error)
            });


    }

    componentDidMount() {
        this.intervalId = setInterval(() => this.reloadData(), 5000);
        // this.reloadData();
    }

    componentWillUnmount() {
        if (this.intervalId) {
            clearInterval(this.intervalId);
        }
    }

    render() {
        return (
            <div>
                <Header/>

                <h2>Filter Rules: <PopupExample reloadData={() => this.reloadData()}/></h2>
                <br/>
                <div style={{marginRight: "30px", marginLeft: "30px"}}>
                    <DenseTable rows={this.state.rows} reloadData={() => this.reloadData()}/>
                </div>
            </div>
        );
    }
}

export default Rules;