<script>
  import { mapState } from 'vuex'

  export default {
    props: {
      classrooms: {
        type: Array,
        default: () => []
      }
    },

    computed: {
      ...mapState('teacherDashboard', {
        currentSelectedClassroom: state => state.classroomId
      }),

      classesTabSelected () {
        return this.$route.path.startsWith('/teachers/classes') || this.$route.path === '/teachers'
      },

      studentProjectsSelected () {
        return this.$route.path.startsWith('/teachers/projects')
      },

      licensesSelected () {
        return this.$route.path.startsWith('/teachers/licenses')
      },

      resourceHubSelected () {
        return this.$route.path.startsWith('/teachers/resources')
      },

      pdSelected () {
        return this.$route.path.startsWith('/teachers/professional-development')
      },

      // Check for the "All Classes" dropdown menu button in the classesTab.
      allClassesSelected () {
        return this.$route.path === '/teachers' || this.$route.path === '/teachers/classes'
      },

      classroomSelected () {
        if (this.allClassesSelected) {
          return undefined
        }
        return this.currentSelectedClassroom
      }
    },

    methods: {
      trackEvent (e) {
        const eventName = e.target.dataset['action']
        const eventLabel = e.target.dataset['label']
        if (eventName) {
          if (eventLabel) {
            window.tracker?.trackEvent(eventName, { category: 'Teachers', label: eventLabel })
          } else {
            window.tracker?.trackEvent(eventName, { category: 'Teachers' })
          }
        }
      }
    }
  }
</script>

<template>
  <ul
    id="secondaryNav"
    class="nav"
    role="navigation"
  >
    <li
      role="presentation"
      class="dropdown"
    >
      <a
        id="ClassesDropdown"
        :class="['dropdown-toggle', classesTabSelected ? 'current-route': '']"
        href="#"
        role="button"
        data-toggle="dropdown"
        aria-haspopup="true"
        aria-expanded="false"
      >
        <div id="IconMyClasses" />
        <span>{{ $t('nav.my_classrooms') }}</span>
        <span class="caret" />
      </a>
      <ul
        class="dropdown-menu"
        aria-labelledby="ClassesDropdown"
      >
        <li :class="allClassesSelected ? 'selected': null">
          <router-link tag="a" to="/teachers" class="dropdown-item underline-item" @click.native="trackEvent" data-action="All Classes: Nav Clicked" data-toggle="dropdown">
            {{ $t('teacher_dashboard.all_classes') }}
          </router-link>
        </li>
        <li
          v-for="classroom in classrooms"
          :key="classroom._id"
          :class="classesTabSelected && classroomSelected === classroom._id ? 'selected': null"
        >
          <router-link
            tag="a"
            :to="`/teachers/classes/${classroom._id}`"
            class="dropdown-item"
            @click.native="trackEvent"
            data-action="Track Progress: Nav Clicked"
            data-toggle="dropdown"
            :data-label="$route.path"
          >
            {{ classroom.name }}
          </router-link>
        </li>
      </ul>
    </li>
    <li
      role="presentation"
      class="dropdown"
    >
      <a
        id="ProjectsDropdown"
        :class="['dropdown-toggle', studentProjectsSelected ? 'current-route': '']"
        href="#"
        role="button"
        data-toggle="dropdown"
        aria-haspopup="true"
        aria-expanded="false"
      >
        <div id="IconCapstone" />
        <span>{{ $t('teacher_dashboard.student_projects') }}</span>
        <span class="caret" />
      </a>
      <ul
        v-if="classrooms.length > 0"
        class="dropdown-menu"
        aria-labelledby="ProjectsDropdown"
      >
        <li
          v-for="classroom in classrooms"
          :key="classroom._id"
          :class="classroomSelected === classroom._id && studentProjectsSelected ? 'selected': null"
        >
          <router-link
            :to="`/teachers/projects/${classroom._id}`"
            class="dropdown-item"
            @click.native="trackEvent"
            data-action="Student Projects: Nav Clicked"
            data-toggle="dropdown"
          >
            {{ classroom.name }}
          </router-link>
        </li>
      </ul>
      <ul
        v-else
        class="dropdown-menu"
        aria-labelledby="ProjectsDropdown"
      >
        <li>
          <a class="dropdown-item disabled-item">
            {{ $t('teacher_dashboard.no_classes_yet') }}
          </a>
        </li>
      </ul>
    </li>
    <li>
      <router-link to="/teachers/licenses" id="LicensesAnchor" :class="{ 'current-route': licensesSelected } " @click.native="trackEvent" data-action="My Licenses: Nav Clicked">
        <div id="IconLicense" />
        {{ $t('teacher_dashboard.my_licenses') }}
      </router-link>
    </li>
    <li>
      <router-link to="/teachers/resources" id="ResourceAnchor" :class="{ 'current-route': resourceHubSelected }" @click.native="trackEvent" data-action="Resource Hub: Nav Clicked">
        <div id="IconResourceHub" />
        {{ $t('teacher_dashboard.resource_hub') }}
      </router-link>
    </li>
    <li>
      <router-link to="/teachers/professional-development" id="PDAnchor" :class="{ 'current-route': pdSelected }" @click.native="trackEvent" data-action="PD: Nav Clicked">
        <div id="IconPD" />
        <div id="IconNew">New!</div>
        {{ $t('teacher_dashboard.pd_short') }}
      </router-link>
    </li>
  </ul>
</template>

<style lang="scss" scoped>
@import "app/styles/bootstrap/variables";
@import "ozaria/site/styles/common/variables.scss";
@import "app/styles/ozaria/_ozaria-style-params.scss";

#IconCapstone {
  background-image: url(/images/ozaria/teachers/dashboard/svg_icons/Icon_Capstone.svg);
  margin-top: -1px;
}

#IconMyClasses {
  background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconMyClasses.svg);
  margin-top: -6px;
}

/* Need aria-expanded for when user has mouse in the dropdown */
#ProjectsDropdown:hover, #ProjectsDropdown.current-route, #ProjectsDropdown[aria-expanded="true"] {
  #IconCapstone {
    background-image: url(/images/ozaria/teachers/dashboard/svg_icons/Icon_Capstone_Blue.svg);
  }
}

#ClassesDropdown:hover, #ClassesDropdown.current-route, #ClassesDropdown[aria-expanded="true"]  {
  #IconMyClasses {
    background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconMyClasses_Blue.svg);
  }
}

#LicensesAnchor:hover , #LicensesAnchor.current-route {
  #IconLicense {
    background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconLicense_Blue.svg);
  }
}

#ResourceAnchor:hover, #ResourceAnchor.current-route {
  #IconResourceHub {
    background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconResourceHub_Blue.svg);
  }
}

#PDAnchor:hover, #PDAnchor.current-route {
  #IconPD {
    background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconPD_Blue.svg);
  }
}

#IconLicense {
  background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconLicense.svg);
  margin-top: -2px;
}

#IconResourceHub {
  background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconResourceHub_White.svg);
  margin-top: -3px;
}

#IconPD {
  background-image: url(/images/ozaria/teachers/dashboard/svg_icons/IconPD_White.svg);
  margin-top: -3px;
}

#IconNew {
  height: 32px;
  width: 32px;
  position: absolute;
  right: 1px;
  top: 1px;
  border-radius: 32px;
  background-color: #e83027;
  color: white;
  font-size: 12px;
  transform: rotate(-20deg);
  text-transform: capitalize;
}

#IconCapstone, #IconMyClasses, #IconLicense, #IconResourceHub, #IconPD {
  height: 23px;
  width: 23px;
  display: inline-block;
  background-repeat: no-repeat;
  background-position: center;

  margin-right: 8px;
}

#secondaryNav {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  padding-left: 23.5px;
  height: 35px;
  min-height: 35px;

  & > li {
    height: 35px;
    width: 230px;
    text-align: center;
    margin: 0 6.5px;

    display: flex;
    justify-content: center;
    align-items: center;

    background-color: $twilight;
    border-radius: 10px 10px 0 0;

    &.dropdown.open > a, & > a:hover, a.current-route {
      background-color: #F2F2F2;
      color: $twilight;
      border: 1px solid #d8d8d8;
      border-bottom: unset;
    }

    a {
      @include font-h-4-navbar-uppercase-white;
      font-size: 14px;

      width: 100%;
      height: 100%;
      padding: 0;

      display:flex;
      flex-direction: row;
      align-items: center;
      justify-content: center;

      & > img {
        margin-top: -6px;
        margin-right: 13px;
      }
    }

    & > a {
      padding-top: 3px;
      border-radius: 10px 10px 0 0;
    }

    .dropdown-menu {
      a {
        color: $twilight;
        height: 35px;
        text-align: left;

        justify-content: start;
        justify-content: flex-start;
      }

      min-width: 230px;
      padding: 0 20px;
    }

    li.selected a {
      color: #979797
    }

    li .underline-item {
      border-bottom: 1px solid #ddd;
    }
    li .disabled-item {
      color: #979797;
      cursor: default;
    }
  }
}
</style>
