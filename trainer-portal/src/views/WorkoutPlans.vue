<template>
<default-layout>
    <div class="container">
           <div class="row workoutHeader text-light mb-4 shadow">
    </div>
        <table class="table table-striped table-hover mt-3">
            <thead class="thead text-light orangeBackground">
            <tr>
            <th scope="col">Done? </th>
            <th scope="col">Focus: </th>
            <th scope="col">Plan: </th>
            <th scope="col">Days Of Week: </th>
            </tr>
            </thead>
            <tbody>
                <tr v-for="workout in workoutPlans" :key="workout.workoutId" v-bind:class="{'workout-completed': workout.completed}">
                    <div class="checkbox-container">
                    <input type="checkbox" v-model="workout.completed" v-on:click="changeStatus(workout.workoutId)"/>
                    </div>
                    <td class="orangeText">{{workout.title}}</td>
                    <td>{{workout.message}}</td>
                    <td>{{weekFlagToText(workout.daysOfWeek)}}</td>
                </tr>
            </tbody>
        </table>
         <div class="row pb-3">
         </div>
    </div>
    
</default-layout>
</template>

<script>
import DefaultLayout from '@/layouts/DefaultLayout';
import auth from '../auth';

export default {
    components: {
        DefaultLayout
    },
    data(){
        return{
            UserID: this.$route.params.UserID,
            workoutPlans: [],
        }
    },
    methods: {
        changeStatus(id) {
            const arrIndex = this.workoutPlans.findIndex((workout) => workout.workoutId == id);
            this.workoutPlans[arrIndex].completed = !this.workoutPlans[arrIndex].completed;
            fetch(`${process.env.VUE_APP_REMOTE_API}/updateWorkoutPlan`, {
                method: 'PUT',
                    headers: new Headers ({
                    Authorization: 'Bearer ' + auth.getToken(),
                    'Content-Type': 'application/json',
                    }),
                    credentials: 'same-origin',
                    body: JSON.stringify(this.workoutPlans[arrIndex]),
                }) 
                    .catch((err) => console.error(err));
        },
        weekFlagToText(weekFlag) {
            var days = [];
            if( weekFlag.charAt(0) === 'T' ) days.push('Sun');
            if( weekFlag.charAt(1) === 'T' ) days.push('Mon');
            if( weekFlag.charAt(2) === 'T' ) days.push('Tue');
            if( weekFlag.charAt(3) === 'T' ) days.push('Wed');
            if( weekFlag.charAt(4) === 'T' ) days.push('Thu');
            if( weekFlag.charAt(5) === 'T' ) days.push('Fri');
            if( weekFlag.charAt(6) === 'T' ) days.push('Sat');
            return days.join(', ');
        },
    },

    created() {
      fetch(`${process.env.VUE_APP_REMOTE_API}/workoutPlans/${this.UserID}`, {
      method: 'GET',
        headers: new Headers ({
          Authorization: 'Bearer ' + auth.getToken(),
        }),
        credentials: 'same-origin',
        }) 
        .then((response) => {
            return response.json();
        })
        .then((json) => {
            this.workoutPlans = json;
        })
        .catch((err) => console.error(err));
    }

}
</script>

<style>


.workoutHeader {
    background-image:  url('/img/FitnessCollage.png');
    background-size: cover;
    background-position: bottom;
    border-radius: 4px;
    height: 250px;

}

tr.workout-completed {
    text-decoration: line-through;
    color: darkgray;
}


</style>